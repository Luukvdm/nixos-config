{
  config,
  lib,
  options,
  pkgs,
  username,
  ...
}: let
  cfg = config.myNixOS.k8s;
  apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
in {
  config = lib.mkIf cfg.enableKubeconfig {
    sops.secrets = {
      "k8s-apitoken-secret" = {
        sopsFile = ../../../../secrets/k8s/apitoken.secret;
        format = "binary";
      };
    };

    sops.templates."kubeconfig" = {
      owner = username;
      path = "/home/${username}/.kube/config";

      content = ''
        apiVersion: v1
        kind: Config
        clusters:
        - name: local
          cluster:
            server: ${apiAddr}
            certificate-authority: ${cfg.caPem}
        users:
        - name: ${username}
          user:
            token: ${config.sops.placeholder."k8s-apitoken-secret"}
        contexts:
        - name: local
          context:
            cluster: local
            user: ${username}
        current-context: default-context
      '';
    };
  };
}
