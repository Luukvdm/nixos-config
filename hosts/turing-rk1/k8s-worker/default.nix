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
      role = "worker";
    };
    # sops = {
    #   secrets = {
    #     k8sCaPem = {
    #       sopsFile = ../../../secrets/k8s/ca.pem;
    #       format = "binary";
    #     };
    #   };
    # };
  };

  environment.systemPackages = with pkgs; [
  ];
}
