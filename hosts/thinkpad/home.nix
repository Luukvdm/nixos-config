{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}: let
  username = "pengu";
in {
  imports = [outputs.homeManagerModules.default];

  sops = {
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = ["/home/${username}/.ssh/nixos/id_ed25519"];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      githubUser = {
        sopsFile = ../../secrets/github.ini;
        format = "ini";
        path = "/home/${username}/.config/git/github";
      };
    };
  };

  myHomeManager = {
    bundles.general.enable = true;
    bundles.gnome-desktop.enable = true;
    firefox.enable = true;
    git = {
      enable = true;
      mainUserFile = config.sops.secrets.githubUser.path;
    };
    go.enable = true;
    nix-direnv.enable = true;
    tilix.enable = true;
    vscode.enable = true;
    xdg.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "24.05";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#use-with-home-manager
    activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
      /run/current-system/sw/bin/systemctl start --user sops-nix
    '';

    packages = with pkgs; [
      insomnia
    ];
  };
}
