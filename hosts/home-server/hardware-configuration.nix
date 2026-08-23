{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  zfsCompatibleKernelPackages =
    lib.filterAttrs (
      name: kernelPackages:
        (builtins.match "linux_[0-9]+_[0-9]+" name)
        != null
        && (builtins.tryEval kernelPackages).success
        && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
    )
    pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = latestKernelPackage;
    kernel = {
      sysctl = {
        "vm.nr_hugepages" = 1024;
      };
    };
    kernelModules = ["kvm-amd" "nvme-tcp"];
    kernelParams = [
      "default_hugepagesz=2M"
      "hugepagesz=2M"
      "hugepages=1024"
    ];
    extraModulePackages = [];
    supportedFilesystems = ["zfs"];
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    zfs = {
      extraPools = ["media-pool" "backup-pool"];
    };
  };
  networking.hostId = "7a35f6be";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9d55b880-c520-40af-8fff-dc817a9c5752";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D38E-9BCF";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/mnt/backup" = {
    device = "backup-pool";
    fsType = "zfs";
  };

  fileSystems."/mnt/media" = {
    device = "media-pool";
    fsType = "zfs";
  };

  swapDevices = lib.mkForce [];
  # swapDevices = [
  #   {device = "/dev/disk/by-uuid/b7086f2d-25ce-4349-8d03-1e4a29515f48";}
  # ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
