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
    enableSshKeyPaths = lib.mkOption {
      type = with lib.types; bool;
      default = true;
      description = ''
        If the sshKeyPaths option should be enabled.
      '';
    };
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
    # TODO
    defaultSopsFile = "/home/${username}/code/github/nixos-config/secrets/secrets.yaml"; # hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = lib.mkIf (cfg.enableSshKeyPaths) ["/home/${username}/.ssh/${cfg.sshKeyDir}/id_ed25519"];
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
