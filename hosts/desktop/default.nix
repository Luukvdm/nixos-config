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
    bundles.general-desktop.enable = true;
    bundles.home-manager.enable = true;
    power-management.enable = false;
    sops = {
      enable = true;
      sshKeyDir = "sops";
    };
    gnome.enable = true;
    neovim.enable = true;
    steam.enable = true;
    rgb.enable = true;
    k8s-tools.enable = true;

    userConfig = ./home.nix;
    user = {
      extraGroups = ["networkmanager" "docker"];
    };
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "desktop";
    networkmanager = {
      enable = true;
    };
  };

  services.fwupd.enable = true;
  services.printing.enable = true;

  hardware.logitech.wireless.enable = true;
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # no need to redefine it in your config for now
    #media-session.enable = true;
  };

  # extra packages
  environment.systemPackages = with pkgs; [
    nix-index
    nixos-generators
    python3
    lvm2

    spotify
    vesktop
    runelite
    fragments
    logitech-udev-rules
    solaar
    gnomeExtensions.solaar-extension

    tpi
  ];
  services.flatpak.enable = true;
}
