# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
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
    gchat.enable = true;
    gnome.enable = true;

    # sharedSettings.hyprland.enable = false;
    userName = "pengu";
    userConfig = ./home.nix;

    # userNixosSettings = {
    #   extraGroups = ["networkmanager" "wheel" "libvirtd" "docker" "adbusers" "openrazer"];
    # };
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
    docker
    docker-compose
    kubectl
    kubectx
    kustomize
    kubernetes-helm
    kind
    k9s
    skaffold
    dapr-cli
    nodejs
    yarn
    electron
    nodePackages_latest.vue-cli
    nodePackages_latest.bash-language-server
    dotnet-sdk
    dotnet-runtime
    terraform
    terraform-ls
    terraform-lsp
    terraform-docs
    jetbrains-toolbox
    jetbrains.goland
    jetbrains.rider
    redocly-cli
    openapi-generator-cli
    delve
    protobuf
    protobufc
    spotify
  ];

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

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.docker.autoPrune.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
