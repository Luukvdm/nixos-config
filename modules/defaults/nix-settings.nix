{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  cfg = config.myNixOS.nix-settings;
in {
  options.myNixOS.nix-settings = {
    trustedUsers = lib.mkOption {
      type = with lib.types; listOf str;
      default = ["root" "@wheel"];
      description = ''
        List of trusted users that have additional rights when connecting to the Nix daemon.
      '';
    };
  };

  config = {
    environment.etc.nixpkgs.source = inputs.nixpkgs;
    environment.etc.self.source = inputs.self;

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = lib.mkDefault ["nix-command" "flakes"];
        auto-optimise-store = lib.mkDefault true;
        builders-use-substitutes = true;
        trusted-users = cfg.trustedUsers;
      };
      # channel.enable = lib.mkDefault false;
      optimise = {
        automatic = lib.mkDefault true;
      };
      gc = {
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
      };
    };

    nixpkgs = {
      overlays = [
        outputs.overlays.additions
        outputs.overlays.modifications
        outputs.overlays.unstable-packages
      ];
      config = {
        allowUnfree = lib.mkDefault true;
      };
    };

    system.stateVersion = "25.05";
  };
}
