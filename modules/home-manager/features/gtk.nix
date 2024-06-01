{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      package = pkgs.cantarell-fonts;
      name = "Cantarell";
      size = 11;
    };

    theme = {
      name = "Adwaita";
      # name = "adw-gtk3-dark";
      # package = pkgs.adw-gtk3;
    };

    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;

        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-cursor-theme-size = 128;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
