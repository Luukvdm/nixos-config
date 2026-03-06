{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-wallpaper = inputs.nix-wallpaper.packages.${pkgs.stdenv.hostPlatform.system}.default;
  mkWallpaper = variant:
    (nix-wallpaper.override {
      preset = variant;
      logoSize = 10;
    })
    + "/share/wallpapers/nixos-wallpaper.png";
in {
  imports = [
    ./dconf.nix
  ];
  dconf.settings = let
    inherit (config.home) homeDirectory;
  in {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${homeDirectory}/.local/share/backgrounds/nixos-l.png";
      picture-uri-dark = "file://${homeDirectory}/.local/share/backgrounds/nixos-d.png";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    # "org/gnome/desktop/screensaver" = {
    #   picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
    #   primary-color = "#3465a4";
    #   secondary-color = "#000000";
    # };
  };

  home = {
    file = let
      inherit (config.home) homeDirectory;
    in {
      ".local/share/backgrounds/nixos-d.png".source = mkWallpaper "gruvbox-dark-rainbow";
      ".local/share/backgrounds/nixos-l.png".source = mkWallpaper "gruvbox-light-rainbow";
      ".local/share/gnome-background-properties/nix.xlm".text = ''
        <?xml version="1.0"?>
        <!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
        <wallpapers>
          <wallpaper deleted="false">
            <name>Tag</name>
            <filename>${homeDirectory}/.local/share/backgrounds/nixos-l.png</filename>
            <filename-dark>${homeDirectory}/.local/share/backgrounds/nixos-d.png</filename-dark>
            <options>zoom</options>
            <!-- <shade_type>solid</shade_type> -->
            <!-- <pcolor>#3071AE</pcolor> -->
            <!-- <scolor>#000000</scolor> -->
          </wallpaper>
        </wallpapers>
      '';
    };
  };
}
