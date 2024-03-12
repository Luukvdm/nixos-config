{
  pkgs,
  config,
  lib,
  ...
}: {
  home.pointerCursor = {
    package = pkgs.phinger-cursors;
    name = "Phinger-cursors";
    gtk.enable = true;
    # x11.enable = true;
  };
}
