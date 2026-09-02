{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gnome-boxes
    libvirt
    OVMF
    swtpm

    spice
    win-spice
    phodav

    # networking backend
    passt

    qemu_kvm
    qemu
  ];
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.enable = true;
  services.spice-vdagentd.enable = true;
  services.gvfs.enable = true;

  myNixOS.user.extraGroups = ["libvirtd" "kvm"];
}
