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
    x11.enable = true;
    size = 64;
  };

  /*
  config = {
    xsession.pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "Phinger-cursors";
      size = 130;
    };
  };
  */
}
