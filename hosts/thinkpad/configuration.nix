{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    outputs.nixosModules.default

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t495

    ./hardware-configuration.nix
  ];

  myNixOS = {
    bundles.general-desktop.enable = true;
    bundles.gnome-desktop.enable = true;
    bundles.home-manager.enable = true;
    power-management.enable = false;
    sops.enable = true;
    gchat.enable = true;
    gnome.enable = true;
    docker.enable = true;
    k8s-tools = {
      enable = true;
    };

    # sharedSettings.hyprland.enable = false;
    userName = "pengu";
    userConfig = ./home.nix;

    # userNixosSettings = {
    #   extraGroups = ["networkmanager" "wheel" "libvirtd" "docker" "adbusers" "openrazer"];
    # };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      # Setup keyfile
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices = {
        "luks-965429fe-d288-4f91-8585-e8324cc7c7ff".device = "/dev/disk/by-uuid/965429fe-d288-4f91-8585-e8324cc7c7ff";
        "luks-965429fe-d288-4f91-8585-e8324cc7c7ff".keyFile = "/crypto_keyfile.bin";
      };
    };
  };

  services.fwupd.enable = true;
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # extra packages
  environment.systemPackages = with pkgs; [
    neovim
    nix-index
    nixos-generators
    python3
    gotop
    gnumake
    gcc
    skaffold
    dapr-cli
    nodePackages_latest.bash-language-server
    redocly-cli
    openapi-generator-cli
    protobuf
    protobufc
    spotify
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
