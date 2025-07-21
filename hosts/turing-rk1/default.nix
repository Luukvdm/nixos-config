{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    outputs.nixosModules.default
    ./base/base.nix
  ];

  myNixOS = {
    networkd = {
      enable = lib.mkDefault true;
      hostname = lib.mkDefault "turing-rk1";
      domain = lib.mkDefault "kube";
      staticIp = lib.mkDefault "192.168.2.9";
    };
    neovim = {
      enable = false;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      go.enable = false;
    };

    user = {
      extraGroups = ["networkmanager" "docker"];
      shell = pkgs.bash;
    };
  };
  security.sudo.wheelNeedsPassword = false;
}
