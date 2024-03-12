{
  inputs,
  outputs,
  pkgs,
  lib,
  ...
}: {
  imports = [outputs.homeManagerModules.default];

  myHomeManager = {
    bundles.general.enable = true;
    # zsh.enabled = true;
    # bundles.general.enable = true;
    # bundles.desktop.enable = true;
    # bundles.gaming.enable = true;

    # firefox.enable = true;
    # pipewire.enable = true;

    # monitors = [
    #   {
    #     name = "eDP-1";
    #     width = 1920;
    #     height = 1080;
    #     refreshRate = 144.003006;
    #     x = 760;
    #     y = 1440;
    #   }
    #   {
    #     name = "DP-2";
    #     width = 3440;
    #     height = 1440;
    #     refreshRate = 144.001007;
    #     x = 0;
    #     y = 0;
    #   }
    # ];
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  # wayland.windowManager.hyprland.settings.master.orientation = "center";

  home = {
    username = "pengu";
    homeDirectory = lib.mkDefault "/home/pengu";
    stateVersion = "22.11";

    packages = with pkgs; [
    ];
  };
}
