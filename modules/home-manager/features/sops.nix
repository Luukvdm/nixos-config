{
  pkgs,
  config,
  lib,
  inputs,
  username,
  ...
}: let
  cfg = config.myHomeManager.sops;
  hostSecretsDir = ../../../secrets;
in {
  options.myHomeManager.sops = {
    secrets = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = ''
        Secrets to decrypt.
      '';
    };

    keyFile = lib.mkOption {
      type = with lib.types; str;
      default = "/home/${username}/.config/sops/age/keys.txt";
      description = ''
      '';
    };
    keyPaths = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      description = ''
      '';
    };
  };

  sops = {
    defaultSopsFile = hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = cfg.keyPaths;
      keyFile = cfg.keyFile;
      generateKey = true;
    };

    secrets = cfg.secrets;
  };
}
