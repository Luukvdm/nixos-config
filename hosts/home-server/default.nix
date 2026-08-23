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
      enable = true;
      enableSshKeyPaths = false;
    };
    networking = {
      enable = true;
      enableNftables = true;
    };
    networkd = {
      enable = true;
      interface = "enp36s0f0";
    };
    k8s = {
      enable = true;
      enableNode = true;
      enableFlannel = false;
      caPem = pkgs.writeTextFile {
        name = "ca.pem";
        text = builtins.readFile ./certs/ca.pem;
      };
      role = "worker";
    };
    neovim = {
      enable = true;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      # go.enable = false;
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
  security.sudo.wheelNeedsPassword = false;

  users = {
    users."${username}" = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTry861vT2EOG89pTKXhcJY/Gf9B/FW/8DLEU+VJKim luuk@desktop"
      ];
    };
    groups.render = {
      gid = 303;
    };
  };

  environment.systemPackages = with pkgs; [
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
