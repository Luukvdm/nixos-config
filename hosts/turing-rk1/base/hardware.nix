{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: let
  rootPartitionUUID = "7a684895-6ef1-4586-98d9-2d2013e98286";
in {
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "nf_tables"
      "raid1"
      "vxlan"
      "iscsi_tcp"
      "cifs"
    ];
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
      "console=ttyS0,115200"
      #   "console=ttyAMA0,115200n8"
      "loglevel=7"
      "console=tty0"
    ];
    kernelPatches = with lib.kernel; [
      {
        name = "rk3588-turing-rk1-fan-curve";
        patch = ./01_rk3588-turing-rk1-fan-curve.patch;
      }
      {
        name = "configure_options";
        patch = null;
        extraStructuredConfig = {
          CRYPTO_USER_API_HASH = module;

          # Enable nf_tables, required for the firewall and docker
          NF_TABLES = module;
          NF_TABLES_INET = yes;
          NFT_NAT = module;
          NFT_CT = module;
          NF_TABLES_NETDEV = yes;
          NETFILTER_NETLINK_HOOK = module;
          NFT_NUMGEN = module;
          NFT_CONNLIMIT = module;
          NFT_LOG = module;
          NFT_LIMIT = module;
          NFT_MASQ = module;
          NFT_REDIR = module;
          NFT_TUNNEL = module;
          NFT_QUOTA = module;
          NFT_REJECT = module;
          NFT_REJECT_INET = module;
          NFT_COMPAT = module;
          NFT_HASH = module;
          NFT_SOCKET = module;
          NFT_OSF = module;
          NFT_TPROXY = module;
          NFT_SYNPROXY = module;
          NF_DUP_NETDEV = module;
          NFT_DUP_NETDEV = module;
          NFT_FWD_NETDEV = module;
          NFT_REJECT_NETDEV = module;
          NETFILTER_XTABLES = module;
          NETFILTER_XT_MATCH_PKTTYPE = module;
          NETFILTER_XT_MATCH_COMMENT = module;
          NETFILTER_XT_MATCH_STATISTIC = module;

          # Enable RAID 1
          MD_RAID1 = module;

          # Enable vxlan for k8s flannel
          VXLAN = module;
          NF_FLOW_TABLE = module;
          NF_FLOW_TABLE_PROCFS = yes;
          NETFILTER_XT_TARGET_CT = module;
          NFT_DUP_IPV4 = module;
          NFT_FIB_IPV4 = module;
          NF_TABLES_ARP = yes;
          IP_NF_ARP_MANGLE = module;
          NFT_DUP_IPV6 = module;
          NFT_FIB_IPV6 = module;
          NF_TABLES_BRIDGE = module;
          NFT_BRIDGE_META = module;
          NFT_BRIDGE_REJECT = module;
          NET_ACT_CT = module;
          NFT_FLOW_OFFLOAD = module;
          NFT_FIB_INET = module;
          NFT_FIB_NETDEV = module;
          NF_FLOW_TABLE_INET = module;

          # containerd
          CFS_BANDWIDTH = yes;

          # traefik
          NETFILTER_XT_MATCH_MULTIPORT = module;

          # iscsi
          ISCSI_TCP = module;

          # metallb
          NETFILTER_XT_MATCH_RECENT = module;

          # CONFIG_CIFS = module;

          CIFS_STATS2 = yes;
          CIFS_ALLOW_INSECURE_LEGACY = no;

          CIFS_UPCALL = lib.mkForce no;
          CIFS_XATTR = yes;
          CIFS_DEBUG = yes;
          CIFS_DEBUG2 = yes;
          CIFS_DEBUG_DUMP_KEYS = no;
          CIFS_DFS_UPCALL = yes;
          CIFS_SWN_UPCALL = yes;
        };
      }
    ];
    supportedFilesystems = [
      "vfat"
      "fat32"
      "exfat"
      "ext4"
      "btrfs"
    ];
    initrd.includeDefaultModules = false;
    initrd.availableKernelModules = [
      "nvme"
      "mmc_block"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  hardware = {
    deviceTree = {
      name = "rockchip/rk3588-turing-rk1.dtb";
      overlays = [];
    };

    firmware = [];
  };
}
