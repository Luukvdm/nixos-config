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
          path = "${config.xdg.configHome}/git/github";
          # path = "/home/${username}/.config/git/github";
        };
        sueUser = {
          sopsFile = ../../secrets/sue/git.ini;
          format = "ini";
          # path = "${config.xdg.configHome}/git/sue";
          path = "/home/${username}/.config/git/sue";
        };
      };
    };
    firefox.enable = true;
    git = {
      enable = true;
      mainUserFile = config.sops.secrets.githubUser.path;
      sueUserFile = config.sops.secrets.sueUser.path;
    };
    go = {
      enable = true;
      includeGoland = true;
    };
    nix-direnv.enable = true;
    tilix.enable = true;
    vscode.enable = true;
    neovim.enable = true;
    zed.enable = true;
    xdg.enable = true;
    gtk.enable = false;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "25.05";

    packages = with pkgs; [
      insomnia
      glab
      awscli2
      azure-cli
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        gcloud-man-pages
        cloud-run-proxy
      ]))
      hcloud
    ];
  };
}
