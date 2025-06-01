{
  config,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.myNixOS;
in {
  environment = {
    sessionVariables = {
      NAUTILUS_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
      XCURSOR_SIZE = "8"; # default 16 I think
    };

    systemPackages = with pkgs;
      [
        wl-clipboard
        xdg-desktop-portal
        xdg-desktop-portal-gnome
        gtk4
        papirus-icon-theme

        dconf-editor
        zenity
        gnome-bluetooth
        gnome-autoar
        gnome-keyring
        gnome-disk-utility
        gnome-tweaks
        gnome-font-viewer
        gnome-power-manager
        gnome-screenshot
        gnome-themes-extra
        eog
        gnome-calculator
        sushi
        nautilus
        nautilus-python
        simple-scan
      ]
      ++ (with pkgs.gnomeExtensions; [
        dash-to-dock
        appindicator
        removable-drive-menu
        legacy-gtk3-theme-scheme-auto-switcher
      ]);

    gnome.excludePackages =
      (with pkgs; [
        gnome-text-editor
        gnome-console
        # gnome-photos
        gnome-tour
        # gnome-connections
        # snapshot
      ])
      ++ (with pkgs; [
        # cheese # webcam tool
        gnome-music
        epiphany # web browser
        geary # email reader
        # evince # document viewer
        # totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
        # gnome-shell-extensions
        gnome-maps
      ]);
  };
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "tilix";
  };

  programs.xwayland.enable = true;
  programs.dconf.enable = true;
  services = {
    gnome = {
      core-shell.enable = true;
      core-apps.enable = false;
    };
    displayManager = {
      defaultSession = "gnome";
      autoLogin = {
        enable = false;
        user = username;
      };
    };

    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          /*
          autoLogin = {
            delay = 1;
          };
          settings = {
            daemon = {
              AutomaticLoginEnable = "True";
              AutomaticLogin = cfg.userName;
            };
          };
          */
        };
      };
      desktopManager.gnome = {
        enable = true;
        # extraGSettingsOverridePackages = [
        # pkgs.nautilus-open-any-terminal
        # ];
      };
    };
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "text/plain" = ["neovide.desktop"];
      # "application/pdf" = ["zathura.desktop"];
      # "image/*" = ["imv.desktop"];
      # "video/png" = ["mpv.desktop"];
      # "video/jpg" = ["mpv.desktop"];
      # "video/*" = ["mpv.desktop"];
    };
  };
}
