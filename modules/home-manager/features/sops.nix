{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.myHomeManager.sops;
  hostSecretsDir = ../../../secrets;
in {
  options.myHomeManager.sops = {
    sshKeyDir = lib.mkOption {
      type = with lib.types; str;
      default = "nixos";
      description = ''
        Directory in ~/.ssh/ that holds the keys for sops.
      '';
    };

    secrets = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Secrets to decrypt.
      '';
    };
  };

  sops = {
    defaultSopsFile = hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      # sshKeyPaths = ["${config.home.homeDirectory}/.ssh/${cfg.sshKeyDir}/id_ed25519"];
      sshKeyPaths = ["/home/pengu/.ssh/${cfg.sshKeyDir}/id_ed25519"];
      # keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      keyFile = "/home/pengu/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = cfg.secrets;
  };
}
