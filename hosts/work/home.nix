{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  hostSecretsDir,
  ...
}: let
  username = "pengu";
in {
  imports = [outputs.homeManagerModules.default];

  sops = {
    # defaultSopsFile = hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      sshKeyPaths = ["/home/${username}/.ssh/sops/id_ed25519"];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      githubUser = {
        sopsFile = ../../secrets/github.ini;
        format = "ini";
        path = "/home/${username}/.config/git/github";
      };
      sueUser = {
        sopsFile = ../../secrets/sue/git.ini;
        format = "ini";
        path = "/home/${username}/.config/git/sue";
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
      sueUserFile = config.sops.secrets.sueUser.path;
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
      rage
      insomnia
      glab
      awscli2
      # (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      # google-cloud-sdk-gce
    ];
  };
}
