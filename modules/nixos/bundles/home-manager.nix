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
        };
      };
    };
  };
}
