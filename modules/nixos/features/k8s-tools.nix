{
  config,
  lib,
  pkgs,
  ...
}: {
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

    systemPackages = with pkgs; [
      kubectl
      kubectx
      kustomize
      kubernetes-helm
      kind
      k9s
    ];
  };
}
