{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: let
  rootPartitionUUID = "7a684895-6ef1-4586-98d9-2d2013e98286";
in {
  imports = [
    outputs.nixosModules.default
    ./base.nix
    # "${pkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    # "${pkgs.path}/nixos/modules/installer/sd-card/sd-image.nix"
  ];

  # TODO:
  # https://github.com/GiyoMoon/nixos-turing-rk1/blob/main/packages/kernel/default.nix
  # https://nixos.wiki/wiki/Linux_kernel#Custom_configuration
  # https://github.com/delroth/infra.delroth.net/blob/82d99c720d400c741944ee3249e70549ac79149d/roles/homenet/igmp.nix#L15

  myNixOS = {
    bundles.general-headless.enable = true;
    networkd = {
      enable = true;
      hostname = "turing-rk1";
      domain = "kube";
      staticIp = "";
    };
    neovim = {
      enable = false;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      go.enable = false;
    };

    user = {
      extraGroups = ["networkmanager"];
      shell = pkgs.bash;
    };
  };
  security.sudo.wheelNeedsPassword = false;

  sdImage = {
    inherit rootPartitionUUID;

    firmwarePartitionOffset = 16;
    firmwareSize = 10;
    # populateFirmwareCommands = "";

    storePaths = [config.system.build.toplevel];

    populateFirmwareCommands = "";
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    postBuildCommands = ''
      dd if=${pkgs.ubootTuringRK1}/u-boot-rockchip.bin of=$img seek=1 bs=32k conv=notrunc
    '';
  };

  image = {
    extension =
      if config.sdImage.compressImage
      then "img.zst"
      else "img";
    filePath = "sd-card/${config.image.fileName}";
  };
}
