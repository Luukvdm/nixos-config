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

  myHomeManager = {
    bundles.general.enable = true;
    bundles.gnome-desktop.enable = true;
    sops = {
      enable = true;
      sshKeyDir = "sops";
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
    xdg.enable = true;
  };

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
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
    stateVersion = "23.11";
    # https://github.com/Mic92/sops-nix?tab=readme-ov-file#use-with-home-manager
    activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.systemd}/bin/systemctl start --user sops-nix
    '';

    packages = with pkgs; [
      insomnia
      glab
      # awscli2
      # (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      # google-cloud-sdk-gce
    ];
  };
}
