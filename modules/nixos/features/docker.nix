{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.docker;
in {
  options.myNixOS.docker = {
    autoPrune = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        Wether to enable auto prune or not.
      '';
    };
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    package = pkgs.docker;
    autoPrune = {
      enable = cfg.autoPrune;
    };
  };

  environment = {
    shellAliases = {
      docker = "docker ";
      d = "docker ";
      dc = "docker-compose ";
    };

    sessionVariables = {
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker-machine";
    };

    systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  };
}
