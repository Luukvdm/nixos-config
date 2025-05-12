{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  hostSecretsDir,
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
      sshKeyDir = "sops";
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
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "24.11";

    packages = with pkgs; [
    ];
  };
}
