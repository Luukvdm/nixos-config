{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../default.nix
  ];

  myNixOS = {
    k8s = {
      enable = false;
      role = "control";
      caFile = config.sops.secrets.k8sCaPem.path;
    };
    sops = {
      secrets = {
        k8sCaPem = {
          sopsFile = ../../../secrets/k8s/ca.pem;
          format = "binary";
        };
      };
    };
  };
}
