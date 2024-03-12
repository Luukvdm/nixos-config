{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  hostSecretsDir,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS = {
    userName = lib.mkOption {
      default = "pengu";
      description = ''
        username
      '';
    };

    userConfig = lib.mkOption {
      default = ./../../home-manager/pengu.nix;
      description = ''
        home-manager config path
      '';
    };

    userNixosSettings = lib.mkOption {
      default = {};
      description = ''
        NixOS user settings
      '';
    };
  };

  config = {
    programs.zsh.enable = true;

    # programs.hyprland.enable = cfg.sharedSettings.hyprland.enable;
    # programs.hyprland.enableNvidiaPatches = cfg.sharedSettings.hyprland.enable;

    # services.xserver = lib.mkIf cfg.sharedSettings.hyprland.enable {
    #   displayManager = {
    #     defaultSession = "hyprland";
    #   };
    # };

    home-manager = {
      extraSpecialArgs = {
        inherit inputs myLib hostSecretsDir;
        outputs = inputs.self.outputs;
        sharedSettings = cfg.sharedSettings;
      };
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      users = {
        ${cfg.userName} = {...}: {
          imports = [
            (import cfg.userConfig)
            outputs.homeManagerModules.default
          ];
        };
      };
    };

    users.users.${cfg.userName} =
      {
        isNormalUser = true;
        initialPassword = "12345";
        description = cfg.userName;
        shell = pkgs.zsh;
        extraGroups = ["networkmanager" "wheel" "docker"];
      }
      // cfg.userNixosSettings;
  };
}
