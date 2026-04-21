{
  config,
  lib,
  pkgs,
  ...
}: let
  # util = import ./util.nix;
  cfg = config.myNixOS.k8s;
  etcdEndpoints = ["https://${cfg.kubeMasterHostname}:2379"];
  apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
  # caCert = secret "ca";
in {
  options.myNixOS.k8s = {
    kubeMasterIp = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    hostIp = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    kubeMasterApiServerPort = lib.mkOption {
      type = with lib.types; int;
      default = 6443;
    };
    kubeMasterHostname = lib.mkOption {
      type = with lib.types; str;
      default = "api.kube"; # config.networking.fqdnOrHostName;
    };
    role = lib.mkOption {
      description = ''
        Kubernetes role that this machine should take.
      '';
      default = "worker";
      type = lib.types.enum [
        "control"
        "worker"
      ];
    };
    caFile = lib.mkOption {
      type = with lib.types; either str path;
      description = ''
        Cert file path for kubernetes certificate authority
      '';
    };
  };

  # resolve master hostname
  # networking.extraHosts = ''
  #   ${cfg.kubeMasterIp} ${cfg.kubeMasterHostname}
  # '';

  services.kubernetes = {
    # package = pkgs.cross.kubernetes;
    easyCerts = false;
    masterAddress = cfg.kubeMasterHostname;
    apiserverAddress = apiAddr;

    # caFile = "${config.services.kubernetes.secretsPath}/ca.pem"; # util.secret "ca";
    caFile = cfg.caFile;

    pki = {
      enable = true;
      pkiTrustOnBootstrap = false;
      genCfsslAPIToken = false;
      genCfsslAPICerts = false;
      genCfsslCACert = false;
    };

    kubelet = {
      enable = true;
      unschedulable = false;
      # unschedulable = cfg.role == "control";
      # taints = {
      #   master = lib.mkIf (cfg.role == "control") {
      #     key = "node-role.kubernetes.io/master";
      #     value = "true";
      #     effect = "NoSchedule";
      #   };
      # };
      kubeconfig = {
        server = apiAddr;
      };
    };

    apiserver = lib.mkIf (cfg.role == "control") {
      enable = true;

      securePort = cfg.kubeMasterApiServerPort;
      # uses the bind-address by default
      advertiseAddress = cfg.kubeMasterIp;
    };

    scheduler = lib.mkIf (cfg.role == "control") {
      enable = true;
    };
    controllerManager = lib.mkIf (cfg.role == "control") {
      enable = true;
    };
    addonManager = lib.mkIf (cfg.role == "control") {
      enable = true;
    };
    addons = {
      dns = {
        # lib.mkIf (cfg.role == "worker") {
        enable = true;
        coredns = {
          # finalImageTag = "arm64-1.13.1";
          # imageDigest = "sha256:9b9128672209474da07c91439bf15ed704ae05ad918dd6454e5b6ae14e35fee6";
          # sha256 = "sha256:DFdhFRD/KkE7nArCuKOq6Wxtw8hKqzDRrB9YrP0z1FQ=";
          finalImageTag = "1.10.1";
          imageDigest = "sha256:a0ead06651cf580044aeb0a0feba63591858fb2e43ade8c9dea45a6a89ae7e5e";
          imageName = "coredns/coredns";
          sha256 = "0c4vdbklgjrzi6qc5020dvi8x3mayq4li09rrq2w0hcjdljj0yf9";
        };
      };
    };
    proxy = {
      enable = true;
    };
    flannel = {
      enable = true;
    };

    clusterCidr = "10.200.0.0/16"; # the default value
    # caFile = "/var/lib/secrets/kubernetes/ca.pem";
  };

  # systemd.services.etcd = {
  #   environment = {
  #     ETCD_UNSUPPORTED_ARCH = "arm64";
  #   };
  # };
  services.etcd = lib.mkIf (cfg.role == "control") {
    enable = true;
  };
  services.flannel = {
    etcd = {
      endpoints = etcdEndpoints;
    };
  };

  environment = {
    shellAliases = {
      k = "kubectl ";
      kcc = "kubectl config current-context";
      kc = "kubectx ";
    };

    systemPackages = with pkgs;
      [
        kubernetes
        kubectl
        k9s

        nftables
      ]
      ++ [
        # cross.kubernetes
        # cross.kubectl
        # cross.k9s
        # cross.binutils # gnat-bootstrap
      ];
  };
}
