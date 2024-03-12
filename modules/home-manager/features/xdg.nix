{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    xdg-user-dirs
    xdg-utils
    xdg-launch
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome
  ];

  xdg = {
    enable = true;
    # configHome = "/home/${userName}/.config";
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "desktop";
      documents = "documents";
      download = "downloads";
      music = "music";
      pictures = "pictures";
      publicShare = "public";
      templates = "templates";
      videos = "videos";
    };
  };
}
