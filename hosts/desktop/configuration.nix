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

    userName = "pengu";
    userConfig = ./home.nix;
  };

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

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
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
    gotop
    spotify
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
