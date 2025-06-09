{
  lib,
  pkgs,
  ...
}: {
  myNixOS = {
    locale.enable = true;
    fonts.enable = true;
  };

  environment.systemPackages = with pkgs; [btop vlc];
  programs = {
    git = {
      enable = true;
    };
  };
}
