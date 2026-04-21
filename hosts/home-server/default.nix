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
    ./hardware-configuration.nix
  ];

  myNixOS = {
    bundles.general-headless.enable = true;
    sops = {
      enable = false;
    };
    networking = {
      enable = true;
      hostname = "home-server";
    };
    networkd = {
      enable = true;
      hostname = "home-server";
      staticIp = "192.168.2.13";
      interface = "enp8s0";
      staticGateway = "192.168.2.254";
    };
    neovim = {
      enable = true;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      go.enable = false;
    };
    # k8s-tools = {
    #   enable = false;
    #   installPackages = false;
    # };

    user = {
      extraGroups = ["networkmanager" "docker"];
      shell = pkgs.bash;
    };
  };

  users.users."${username}" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTry861vT2EOG89pTKXhcJY/Gf9B/FW/8DLEU+VJKim luuk@desktop"
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  security.sudo.wheelNeedsPassword = false;
}
