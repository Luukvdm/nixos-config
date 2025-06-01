{
  lib,
  pkgs,
  ...
}: {
  myNixOS = {
    locale.enable = true;
    openssh.enable = true;
  };

  programs = {
    git = {
      enable = true;
    };
  };

  documentation = {
    man.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };
}
