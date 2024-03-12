{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    # inputs.nix-colors.homeManagerModules.default
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      experimental-features = "nix-command flakes";
    };
  };

  myHomeManager.zsh.enable = lib.mkDefault true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nix-index

    zsh
    file
    bat
    fzf
    jq
    ripgrep
    tree

    wget
    curl
    dig

    git
  ];
}
