{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s;

  ciliumValues = pkgs.writeTextFile {
    name = "cilium-values.yaml";
    text = builtins.readFile ./bootstrap/cilium-values.yaml;
  };
  argocdValues = pkgs.writeTextFile {
    name = "argocd-values.yaml";
    text = builtins.readFile ./bootstrap/argocd-values.yaml;
  };

  ciliumResources = pkgs.writeTextFile {
    name = "cilium-resources.yaml";
    text = builtins.readFile ./bootstrap/resources/cilium.yaml;
  };
  appOfApps = pkgs.writeTextFile {
    name = "app-of-apps.yaml";
    text = builtins.readFile ./bootstrap/resources/app-of-apps.yaml;
  };
  argocdAppProject = pkgs.writeTextFile {
    name = "argo-app-project.yaml";
    text = builtins.readFile ./bootstrap/resources/argo-app-project.yaml;
  };
in {
  options.myNixOS.k8s.bootstrap = {
    cilium = {
      enable = lib.mkOption {
        type = with lib.types; bool;
        default = true;
      };
      version = lib.mkOption {
        type = with lib.types; str;
        default = "1.19.4";
      };
      namespace = lib.mkOption {
        type = with lib.types; str;
        default = "kube-system";
      };
    };
    argocd = {
      version = lib.mkOption {
        type = with lib.types; str;
        default = "9.5.14";
      };
      namespace = lib.mkOption {
        type = with lib.types; str;
        default = "argocd";
      };
    };
  };

  config = {
    sops.secrets = {
      "pihole-password" = {
        sopsFile = ../../../../secrets/k8s/pihole-password;
        format = "binary";
      };
      "deploy-pk" = {
        sopsFile = ../../../../secrets/k8s/gh-deploy/id_ed25519;
        format = "binary";
      };
      "deploy-key" = {
        sopsFile = ../../../../secrets/k8s/gh-deploy/id_ed25519;
        format = "binary";
      };
      "rauthy-env" = {
        sopsFile = ../../../../secrets/k8s/rauthy-env;
        format = "dotenv";
      };
    };

    # cilium config
    environment = lib.mkIf cfg.bootstrap.cilium.enable {
      systemPackages = with pkgs; [cilium-cli];
    };
    networking = lib.mkIf cfg.bootstrap.cilium.enable {
      firewall = {
        checkReversePath = "loose";
        trustedInterfaces = ["cilium_host" "cilium_net" "cilium_vxlan" "lxc+" "lxc*"];
        allowedTCPPorts = [
          4240 # cilium-health checks
          # 4244 # Hubble for observability
          # 4245 # Hubble Relay
        ];
        allowedUDPPorts = [
          8472 # Cilium VXLAN overlay
          # 51871 # Wireguard encryption
        ];
      };
      dhcpcd.denyInterfaces = [
        "mynet*"
        "cilium*" # Ignore Cilium's routing interfaces
        "lxc*" # Ignore the veth pairs Cilium creates for individual pods
      ];
    };

    systemd.services."kubernetes-bootstrap" = lib.mkIf cfg.enableBootstrap {
      path = with pkgs; [
        kubectl
        kubernetes-helm
      ];
      environment = {
        KUBECONFIG = "/etc/kubernetes/cluster-admin.kubeconfig";
      };
      after = ["kubelet.service"];
      script = ''
        ${pkgs.kubernetes-helm}/bin/helm repo add cilium https://helm.cilium.io/
        ${pkgs.kubernetes-helm}/bin/helm upgrade \
          -i cilium cilium/cilium \
          --version ${cfg.bootstrap.cilium.version} \
          -f ${ciliumValues} \
          --set k8sServiceHost=${cfg.kubeMasterIp} \
          --set k8sServicePort=${toString cfg.kubeMasterApiServerPort} \
          --set cni.binPath=${cfg.cniBinPath} \
          --namespace=${cfg.bootstrap.cilium.namespace} \
          --create-namespace
        ${pkgs.kubectl}/bin/kubectl apply --server-side --force-conflicts -f ${ciliumResources}

        ${pkgs.kubernetes-helm}/bin/helm upgrade \
          -i argocd oci://ghcr.io/argoproj/argo-helm/argo-cd \
          --version ${cfg.bootstrap.argocd.version} \
          -f ${argocdValues} \
          --namespace=${cfg.bootstrap.argocd.namespace} \
          --create-namespace --wait

        ${pkgs.kubectl}/bin/kubectl create secret generic github-repo-infra \
          --namespace argocd \
          --from-literal=name=github-luukvdm-infra \
          --from-literal=project=home \
          --from-literal=type=git \
          --from-literal=url=git@github.com:Luukvdm/infra.git \
          --from-file=sshPrivateKey=<(tr -d '\n' < ${config.sops.secrets."deploy-key".path}) \
          --dry-run=client -o yaml | ${pkgs.kubectl}/bin/kubectl apply --server-side --force-conflicts -f -
        ${pkgs.kubectl}/bin/kubectl label secrets github-repo-infra \
          --namespace argocd \
          argocd.argoproj.io/secret-type=repository --overwrite=true

        ${pkgs.kubectl}/bin/kubectl create secret generic pihole \
          --namespace dns \
          --from-file=password=<(tr -d '\n' < ${config.sops.secrets."pihole-password".path}) \
          --dry-run=client -o yaml | ${pkgs.kubectl}/bin/kubectl apply --server-side --force-conflicts -f -

        ${pkgs.kubectl}/bin/kubectl create secret generic rauthy-config --namespace rauthy \
          --from-env-file=${config.sops.secrets."rauthy-env".path} \
          --overwrite=true

        ${pkgs.kubectl}/bin/kubectl apply --server-side -f ${appOfApps}
        ${pkgs.kubectl}/bin/kubectl apply --server-side -f ${argocdAppProject}
      '';
      serviceConfig = {
        # Slice = "kubernetes.slice";
        # MemoryAccounting = true;
        Restart = "on-failure";
        RestartSec = "5000ms";
      };
    };
  };
}
