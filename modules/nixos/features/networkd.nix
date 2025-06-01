{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myNixOS.networkd;
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
    staticIp = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
    staticGateway = lib.mkOption {
      type = with lib.types; str;
      default = "";
    };
  };

  systemd = {
    network = {
      enable = true;
      networks."10-lan" = {
        matchConfig.Name = cfg.interface;
        DHCP = cfg.staticIp != "";
        dhcpV4Config = {
          SendHostname = true;
          Hostname = cfg.hostname;
        };
        networkConfig = lib.mkMerge [
          (lib.mkIf (cfg.staticIp == "") {
            # start a DHCP Client for IPv4 Addressing/Routing
            DHCP = "ipv4";
            # accept Router Advertisements for Stateless IPv7 Autoconfiguraton (SLAAC)
            IPv6AcceptRA = true;
          })
        ];
        address = lib.mkIf (cfg.staticIp != "") [
          "${cfg.staticIp}"
        ];
        routes = lib.mkIf (cfg.staticGateway != "") [
          {
            Gateway = "${cfg.staticGateway}";
          }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };

  networking = {
    firewall.enable = true;
    useDHCP = false;
    useNetworkd = lib.mkDefault true;
    hostName = cfg.hostname;
    domain = cfg.domain;
  };
}
