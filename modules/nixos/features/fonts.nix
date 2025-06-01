{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      powerline-fonts
      font-awesome
      nerd-fonts.hack
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.go-mono
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
