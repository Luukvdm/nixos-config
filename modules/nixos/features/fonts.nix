{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      powerline-fonts
      font-awesome
      (nerdfonts.override {fonts = ["Hack" "DejaVuSansMono" "Go-Mono"];})
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Cantarell"];
        sansSerif = ["Cantarell"];
        monospace = ["Hack Nerd Font"];
      };
    };
  };
}
