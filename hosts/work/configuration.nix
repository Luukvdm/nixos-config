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

    inputs.nixos-hardware.nixosModules.framework-13-7040-amd

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  myNixOS = {
    bundles.general-desktop.enable = true;
    bundles.gnome-desktop.enable = true;
    bundles.home-manager.enable = true;
    power-management.enable = false;
    sops = {
      enable = true;
      sshKeyDir = "sops";
    };
    gnome.enable = true;
    docker.enable = true;
    k8s-tools.enable = true;
    terraform.enable = true;
    clamav = {
      enable = true;
      includeGui = true;
    };
    dotnet = {
      enable = true;
      includeRider = true;
    };

    userName = "pengu";
    userConfig = ./home.nix;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      luks.devices = {
        "luks-97a684f5-6420-4919-88e3-17c9aee9590c".device = "/dev/disk/by-uuid/97a684f5-6420-4919-88e3-17c9aee9590c";
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
    };
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      pingLimit = "1/minute burst 5 packets";
    };
  };

  services.fwupd.enable = true;
  services.printing.enable = true;

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
  # TODO: Move into modules
  environment.systemPackages = with pkgs; [
    nix-index
    nixos-generators
    python3
    gotop
    gnumake
    gcc
    skaffold
    dapr-cli
    protobuf
    protobufc
    spotify

    google-chat-linux
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
