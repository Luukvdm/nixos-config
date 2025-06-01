{
  pkgs,
  system,
  inputs,
  config,
  lib,
  myLib,
  username,
  ...
}: let
  cfg = config.myHomeManager;

  # Taking all modules in ./features and adding enable to them
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);

  # Taking all module bundles in ./bundles and adding bundles.enable to them
  bundles =
    myLib.extendModules
    (name: {
      extraOptions = {
        myHomeManager.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };

      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myLib.filesIn ./bundles);
in {
  options.myHomeManager.username = lib.mkOption {
    type = with lib.types; str;
    default = username;
  };

  imports =
    []
    ++ features
    ++ bundles;
}
