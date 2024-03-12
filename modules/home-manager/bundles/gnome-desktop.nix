{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    # inputs.nix-colors.homeManagerModules.default
  ];

  myHomeManager.gnome.enable = lib.mkDefault true;
  myHomeManager.xdg.enable = lib.mkDefault true;
  myHomeManager.phinger-cursors.enable = lib.mkDefault true;
  # myHomeManager.tilix.enable = lib.mkDefault true;
  # myHomeManager.firefox.enable = lib.mkDefault true;

  home.packages = with pkgs; [
  ];
}
