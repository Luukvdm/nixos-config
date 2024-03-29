{
  pkgs,
  config,
  lib,
  inputs,
  outputs,
  myLib,
  ...
}: let
  cfg = config.myNixOS;

  # Taking all modules in ./features and adding enable to them
  features =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.${name}.enable = lib.mkEnableOption "enable my ${name} configuration";
      };

      configExtension = config: (lib.mkIf cfg.${name}.enable config);
    })
    (myLib.filesIn ./features);

  # Taking all module bundles in ./bundles and adding bundle.enable to them
  bundles =
    myLib.extendModules
    (name: {
      extraOptions = {
        myNixOS.bundles.${name}.enable = lib.mkEnableOption "enable ${name} module bundle";
      };

      configExtension = config: (lib.mkIf cfg.bundles.${name}.enable config);
    })
    (myLib.filesIn ./bundles);
  # Taking all module services in ./services and adding services.enable to them
  # services =
  #   myLib.extendModules
  #   (name: {
  #     extraOptions = {
  #       myNixOS.services.${name}.enable = lib.mkEnableOption "enable ${name} service";
  #     };
  #     configExtension = config: (lib.mkIf cfg.services.${name}.enable config);
  #   })
  #   (myLib.filesIn ./services);
in {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    ++ features
    ++ bundles;
  # ++ services;

  options.myNixOS = {
    sharedSettings = {
      # hyprland.enable = lib.mkEnableOption "enable hyprland";
      gnome.enable = lib.mkEnableOption "enable gnome";
    };
  };

  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
    nix.settings.auto-optimise-store = true;
  };
}
