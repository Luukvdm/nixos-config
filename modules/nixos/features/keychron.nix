{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [
    via
  ];
  environment.systemPackages = with pkgs; [
    qmk
    via
  ];

  boot = {
    extraModprobeConfig = ''
      options hid_apple fnmode=2
    '';
    kernelModules = ["hid-apple"];
    kernelParams = [
      "hid_apple.fnmode=2"
    ];
  };
}
