{
  inputs,
  config,
  lib,
  pkgs,
  hostSecretsDir,
  username,
  ...
}: let
  cfg = config.myNixOS.sops;
in {
  options.myNixOS.sops = {
    sshKeyDir = lib.mkOption {
      type = with lib.types; str;
      default = "sops";
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

  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      # sshKeyPaths = ["${config.home.homeDirectory}/.ssh/${cfg.sshKeyDir}/id_ed25519"];
      sshKeyPaths = ["/home/${username}/.ssh/${cfg.sshKeyDir}/id_ed25519"];
      # keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = cfg.secrets;
  };

  environment = {
    systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  };
}
