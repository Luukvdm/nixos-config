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
      enable = true;
      role = "control";
    };
    sops = {
      secrets = {
        # k8sCaPem = {
        #   sopsFile = ../../../secrets/k8s/ca.pem;
        #   format = "binary";
        # };
      };
    };
  };
}
