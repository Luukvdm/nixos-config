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

  myHomeManager = {
    bundles.general.enable = true;
    bundles.gnome-desktop.enable = true;
    sops = {
      enable = true;
      secrets = {
        githubUser = {
          sopsFile = ../../secrets/github.ini;
          format = "ini";
          # path = "${config.xdg.configHome}/git/github";
          path = "/home/${username}/.config/git/github";
        };
      };
    };
    firefox.enable = true;
    git = {
      enable = true;
      mainUserFile = config.sops.secrets.githubUser.path;
    };
    go = {
      enable = true;
      includeGoland = true;
    };
    nix-direnv.enable = true;
    tilix.enable = true;
    vscode.enable = true;
    xdg.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "23.11";

    packages = with pkgs; [
      insomnia
    ];
  };
}
