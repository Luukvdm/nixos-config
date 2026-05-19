{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s;
  # etcdEndpoints = ["https://${cfg.kubeMasterHostname}:2379"];
  # apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
in {
  imports = [
    ./node.nix
    ./kubeconfig.nix
    ./bootstrap.nix
  ];

  options.myNixOS.k8s = {
    enableNode = lib.mkOption {
      type = with lib.types; bool;
      default = false;
    };
    enableKubeconfig = lib.mkOption {
      type = with lib.types; bool;
      default = false;
    };
    enableBootstrap = lib.mkOption {
      type = with lib.types; bool;
      default = false;
    };

    kubeMasterIp = lib.mkOption {
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
    hostIp = lib.mkOption {
      type = with lib.types; str;
      default = "";
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
    enableFlannel = lib.mkOption {
      type = with lib.types; bool;
      default = false;
    };
    cniBinPath = lib.mkOption {
      type = with lib.types; either str path;
      default = "/var/lib/cni/bin/";
      description = ''
        By default this is `/opt/cni/bin/` but kubelet deletes everything in that directory excluding the binaries set with config.
        But because Cilium copies it's binaries in there form the pod with host path mounts, that breaks the Cilium setup.
      '';
    };
    caPem = lib.mkOption {
      type = with lib.types; either str path;
      description = ''
        ca.pem
      '';
    };
  };

  config = {
    environment = {
      shellAliases = {
        k = "kubectl ";
        kcc = "kubectl config current-context";
        kc = "kubectx ";
      };

      systemPackages = with pkgs; [
        kubectl
        k9s
        kubectx
        cfssl
      ];
    };
  };
}
