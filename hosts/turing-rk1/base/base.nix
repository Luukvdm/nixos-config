{
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  myNixOS = {
    bundles.general-headless.enable = true;
    sops = {
      enable = true;
      sshKeyDir = "sops";
    };
  };

  nixpkgs = {
    config = {
      allowUnsupportedSystem = true;
      allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          # includes proprietary binaries from Rockchip
          "ubootTuringRK1"
        ];
    };
  };

  users.users."${username}" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTry861vT2EOG89pTKXhcJY/Gf9B/FW/8DLEU+VJKim luuk@desktop"
    ];
  };
}
