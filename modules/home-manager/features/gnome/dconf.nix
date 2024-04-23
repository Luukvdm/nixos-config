{
  config,
  pkgs,
  ...
}: {
  dconf.settings = {
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      workspaces-only-on-primary = true;
      experimental-features = ["scale-monitor-framebuffer"];
    };
    "org/gnome/shell" = {
      favorite-apps = [
        "com.gexperts.Tilix.desktop"
        "org.gnome.Nautilus.desktop"
        "spotify.desktop"
        "firefox-devedition.desktop"
        "goland.desktop"
      ];
      enable-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "dash-to-dock@micxgx.gmail.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
      ];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      dash-max-icon-size = 64;
      animate-show-app = false;
      show-trash = false;
      show-mounts-network = true;
      running-indicator-style = "DOTS";
      transparency-mode = "DYNAMIC";
      background-opacity = 0.8;
      custom-background-color = true;
      background-color = "rgb(36,31,49)";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      font-name = "Cantarell 11";
      document-font-name = "Cantarell 11";
      monospace-font-name = "Hack Nerd Font 10";
      gtk-theme = "Adwaita";
      icon-theme = "Papirus-Dark";
      cursor-theme = "phinger-cursors";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/sound" = {
      theme-name = "freedesktop";
    };
    "org/gnome/desktop/default-application/terminal" = {
      exec = "tilix";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      click-method = "areas";
      disable-while-typing = false;
    };
    "org/gnome/settings-daemon/plugins/housekeeping" = {
      free-size-gb-no-notify = 5;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      www = ["<Super>w"];
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = ["/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "tilix";
      name = "Launch Terminal";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      # night-light-last-coordinates = (51.592, 4.780);
      night-light-temperature = "uint32 2632";
    };
    # "org/gnome/desktop/background" = {
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-l.png";
    #   picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    # };
    # "org/gnome/desktop/screensaver" = {
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    #   primary-color = "#3465a4";
    #   secondary-color = "#000000";
    # };
  };
}
