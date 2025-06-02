{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  imports = [outputs.homeManagerModules.default];

  myHomeManager = {
    username = username;
    bundles.general.enable = true;
    bundles.gnome-desktop.enable = true;
    sops = {
      enable = true;
      keyPaths = ["/home/${username}/.ssh/sops/id_ed25519"];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
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
    nix-direnv.enable = true;
    tilix.enable = true;
    neovim.enable = true;
    zed.enable = true;
    xdg.enable = true;
    gtk.enable = false;
    go.enable = true;
    vscode.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
    ];
  };
}
