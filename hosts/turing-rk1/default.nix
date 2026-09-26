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
    ./hardware.nix
  ];

  myNixOS = {
    bundles.general-headless.enable = true;
    sops = {
      enable = true;
      enableSshKeyPaths = false;
      sshKeyDir = "sops";
    };
    networking = {
      enable = true;
      hostname = lib.mkDefault "turing-rk1";
      domain = lib.mkDefault "kube";
      enableFirewall = false;
      enableNftables = true;
    };
    networkd = {
      enable = lib.mkDefault true;
      hostname = lib.mkDefault "turing-rk1";
      domain = lib.mkDefault "kube";
      # staticIp = lib.mkDefault "192.168.2.9";
      staticIp = "";
    };
    k8s = {
      enableNode = true;
      enableFlannel = false;
      caPem = pkgs.writeTextFile {
        name = "ca.pem";
        text = builtins.readFile ./certs/ca.pem;
      };
      nodeLabels = {
        "openebs.io/engine" = "mayastor";
        "storage-tier" = "nvme";
      };
    };
    neovim = {
      enable = false;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      # go.enable = false;
    };
    # k8s-tools = {
    #   enable = false;
    #   installPackages = false;
    # };

    user = {
      extraGroups = ["networkmanager" "docker"];
      shell = pkgs.bash;
    };
  };
  security.sudo.wheelNeedsPassword = false;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
          "ubootTuringRK1"
        ];
    };
  };

  users.users."${username}" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDTry861vT2EOG89pTKXhcJY/Gf9B/FW/8DLEU+VJKim luuk@desktop"
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim-unwrapped
  ];

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
