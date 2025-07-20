{
  lib,
  pkgs,
  username,
  ...
}: {
  myNixOS = {
    locale.enable = true;
    fonts.enable = true;
  };

  environment.systemPackages = with pkgs; [btop vlc nmap];
  programs = {
    git = {
      enable = true;
    };

    nh = {
      enable = true;
      flake = "/home/${username}/code/github/nixos-config";
    };
  };
}
