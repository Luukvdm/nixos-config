{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [outputs.homeManagerModules.default];

  myHomeManager = {
    bundles.general.enable = true;
    bundles.gnome-desktop.enable = true;
    go.enable = true;
    git = {
      enable = true;
    };
    nix-direnv.enable = true;
    xdg.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = "pengu";
    homeDirectory = lib.mkDefault "/home/pengu";
    stateVersion = "24.05";

    packages = with pkgs; [
      insomnia
      glab
      awscli2
    ];
  };
}
