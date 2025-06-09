{
  lib,
  config,
  inputs,
  outputs,
  myLib,
  pkgs,
  hostSecretsDir,
  username,
  ...
}: let
  cfg = config.myNixOS;
in {
  options.myNixOS = {
    userConfig = lib.mkOption {
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

    home-manager = {
      extraSpecialArgs = {
        inherit inputs myLib hostSecretsDir username;
        outputs = inputs.self.outputs;
        sharedSettings = cfg.sharedSettings;
      };
      sharedModules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
      useGlobalPkgs = lib.mkDefault true;
      users = {
        ${username} = {...}: {
          imports = [
            (import cfg.userConfig)
            outputs.homeManagerModules.default
          ];

          myHomeManager = {
            gnome.enable = lib.mkDefault cfg.gnome.enable;
            xdg.enable = lib.mkDefault cfg.gnome.enable;
            phinger-cursors.enable = lib.mkDefault cfg.gnome.enable;
            # tilix.enable = lib.mkDefault cfg.gnome.enable;
            # firefox.enable = lib.mkDefault cfg.gnome.enable;
          };
        };
      };
    };
  };
}
