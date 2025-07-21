{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myNixOS.networkd;
  useDhcp = cfg.staticIp != "";
in {
  options.myNixOS.networkd = {
    interface = lib.mkOption {
      type = with lib.types; str;
      default = "end0";
      description = ''
        Network interface to configure.
      '';
    };
    hostname = lib.mkOption {
      type = with lib.types; str;
    };
    domain = lib.mkOption {
      type = with lib.types; str;
    };
    extraHosts = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
    staticIp = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    staticGateway = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    dns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = ["1.1.1.1" "208.67.222.222"];
    };
  };

  systemd = {
    network = {
      enable = true;
      networks."10-lan" = lib.mkMerge [
        {
          matchConfig.Name = cfg.interface;
          dns = cfg.dns;
          linkConfig.RequiredForOnline = "routable";
        }
        (lib.mkIf (cfg.staticIp == "") {
          # start a DHCP Client for IPv4 Addressing/Routing
          DHCP = "ipv4";
          networkConfig = {
            DHCP = "ipv4";
            # accept Router Advertisements for Stateless IPv7 Autoconfiguraton (SLAAC)
            IPv6AcceptRA = true;
          };
          dhcpV4Config = {
            SendHostname = true;
            Hostname = cfg.hostname;
          };
        })
        (lib.mkIf (cfg.staticIp != "") {
          DHCP = null;
          address = ["${cfg.staticIp}/24"];
          routes = [
            {
              Gateway = "${cfg.staticGateway}";
            }
          ];
        })
      ];
    };
  };

  networking = {
    firewall.enable = true;
    useDHCP = false; # !builtins.hasContext cfg.staticIp;
    useNetworkd = lib.mkDefault true;
    hostName = cfg.hostname;
    domain = cfg.domain;

    networkmanager = {
      enable = false;
    };
  };
}
