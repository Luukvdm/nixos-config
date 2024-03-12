{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  hostSecretsDir,
  ...
}: {
  imports = [
    outputs.nixosModules.default

    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.sops-nix.nixosModules.sops

    ./hardware-configuration.nix
  ];

  sops = {
    # This will add secrets.yml to the nix store
    # You can avoid this by adding a string to the full path instead, i.e.
    # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
    # defaultSopsFile = ./secrets/example.yaml;
    defaultSopsFile = hostSecretsDir + /secrets.yaml;
    defaultSopsFormat = "yaml";

    # secrets = {
    #   githubUserFile = {
    #     sopsFile = ../../secrets/github.ini;
    #     format = "ini";
    #     owner = config.myNixOS.userName;
    #   };
    # };

    age = {
      sshKeyPaths = ["/home/${config.myNixOS.userName}/.ssh/sops/id_ed25519"];
      keyFile = "/home/${config.myNixOS.userName}/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  myNixOS = {
    bundles.general-desktop.enable = true;
    bundles.gnome-desktop.enable = true;
    bundles.home-manager.enable = true;
    power-management.enable = false;
    gchat.enable = true;
    gnome.enable = true;

    userName = "pengu";
    userConfig = ./home.nix;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      luks.devices = {
        "luks-97a684f5-6420-4919-88e3-17c9aee9590c".device = "/dev/disk/by-uuid/97a684f5-6420-4919-88e3-17c9aee9590c";
      };
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  services.fwupd.enable = true;
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.docker.autoPrune.enable = true;

  # extra packages
  # TODO: Move into modules
  environment.systemPackages = with pkgs; [
    neovim
    nix-index
    nixos-generators
    python3
    gotop
    gnumake
    gcc
    docker
    docker-compose
    kubectl
    kubectx
    kustomize
    kubernetes-helm
    kind
    k9s
    skaffold
    dapr-cli
    nodejs
    yarn
    electron
    nodePackages_latest.vue-cli
    nodePackages_latest.bash-language-server
    dotnet-sdk
    dotnet-runtime
    terraform
    terraform-ls
    terraform-lsp
    terraform-docs
    jetbrains-toolbox
    jetbrains.goland
    jetbrains.rider
    redocly-cli
    openapi-generator-cli
    delve
    protobuf
    protobufc
    spotify
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
