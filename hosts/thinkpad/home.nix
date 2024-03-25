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
    go.enable = true;
    git = {
      enable = true;
    };
    nix-direnv.enable = true;
    xdg.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = "pengu";
    homeDirectory = lib.mkDefault "/home/pengu";
    stateVersion = "24.05";

    packages = with pkgs; [
      insomnia
      glab
      awscli2
    ];
  };
}
