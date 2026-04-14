{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s-tools;
in {
  options.myNixOS.k8s-tools = {
    installPackages = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Wether to install k8s tool packages.
      '';
    };
  };

  environment = {
    shellAliases = {
      k = "kubectl ";
      kcc = "kubectl config current-context";
      kc = "kubectx ";
    };

    /*
    sessionVariables = {
      MINIKUBE_HOME = "$XDG_DATA_HOME/minikube";
    };
    */

    systemPackages = with pkgs;
      [
      ]
      ++ lib.optionals cfg.installPackages [
        kubectl
        k9s
        kubectx
        kustomize
        kubernetes-helm
      ];
  };
}
