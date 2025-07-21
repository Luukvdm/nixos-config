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
      PermitRootLogin = lib.mkDefault "no";
      PasswordAuthentication = lib.mkDefault false;
    };
    openFirewall = lib.mkDefault true;
  };
}
