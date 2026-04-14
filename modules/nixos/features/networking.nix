{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myNixOS.networking;
  useDhcp = cfg.staticIp != "";
in {
  options.myNixOS.networking = {
    enableNetworkmanager = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Wether to NetworkManager.
      '';
    };
    enableFirewall = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Wether to the firewall.
      '';
    };
    enableNftables = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Wether to the nftables.
      '';
    };

    hostname = lib.mkOption {
      type = with lib.types; str;
    };
    domain = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    extraHosts = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
  };

  networking = {
    hostName = cfg.hostname;
    domain = cfg.domain;
    extraHosts = lib.strings.concatLines cfg.extraHosts;

    networkmanager = {
      enable = cfg.enableNetworkmanager;
    };
    firewall = {
      enable = cfg.enableFirewall;
      pingLimit = "1/minute burst 5 packets";
    };
    nftables = {
      enable = cfg.enableNftables;
    };
  };
}
