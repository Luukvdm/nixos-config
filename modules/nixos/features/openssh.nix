{
  lib,
  config,
  pkgs,
  ...
}: {
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = lib.mkDefault true;
  };
}
