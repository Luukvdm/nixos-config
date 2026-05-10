{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s;
  apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
in {
  options.myNixOS.k8s = {
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

    caPem = lib.mkOption {
      type = with lib.types; either str path;
      description = ''
        ca.pem
      '';
    };
  };

  security.pki.certificateFiles = [cfg.caPem];

  environment = {
    shellAliases = {
      k = "kubectl ";
      kcc = "kubectl config current-context";
      kc = "kubectx ";
    };

    systemPackages = with pkgs; [
      kubectl
      k9s
    ];
  };

  imports = [
    ./node.nix
  ];
}
