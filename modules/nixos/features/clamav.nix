{
  config,
  lib,
  pkgs,
  options,
  ...
}: let
  cfg = config.myNixOS.clamav;
in {
  options.myNixOS.clamav = {
    includeGui = lib.mkOption {
      type = with lib.types; bool;
      default = false;
      description = ''
        Wether to include a GUI for ClamAV.
      '';
    };
  };
  services.clamav = {
    daemon = {
      enable = true;
    };
    scanner = {
      enable = true;
      interval = "*-*-* 12:30:00";
    };
    updater = {
      enable = true;
    };
  };

  environment = {
    systemPackages =
      [
      ]
      ++ lib.optionals cfg.includeGui [
        pkgs.clamtk
      ];
  };
}
