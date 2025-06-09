{
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  cfg = config.myNixOS.user;
  defaultUser = username;
in {
  options.myNixOS.user = {
    username = lib.mkOption {
      type = with lib.types; str;
      default = "${defaultUser}";
      description = ''
        Default user on the system.
      '';
    };
    hashedPassword = lib.mkOption {
      type = with lib.types; nullOr (passwdEntry str);
      default = null;
      description = ''
        Password for the default usert.
      '';
    };
    extraGroups = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };

    shell = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.zsh;
    };

    userNixosSettings = lib.mkOption {
      default = {};
      description = ''
        NixOS user settings
      '';
    };
  };

  config = {
    users.users."${cfg.username}" =
      {
        hashedPassword = cfg.hashedPassword;
        initialPassword = "@Welcome01";
        isNormalUser = true;
        home = "/home/${cfg.username}";
        extraGroups = ["wheel"] ++ cfg.extraGroups;
        shell = cfg.shell;
      }
      // cfg.userNixosSettings;
  };
}
