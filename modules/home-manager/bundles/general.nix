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

  # nixpkgs = {
  #   config = {
  #     allowUnfree = true;
  #     experimental-features = "nix-command flakes";
  #   };
  # };

  myHomeManager.zsh.enable = lib.mkDefault true;
  myHomeManager.starship.enable = lib.mkDefault true;
  myHomeManager.xdg.enable = lib.mkDefault true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nix-index

    file
    bat
    fzf
    jq
    ripgrep
    tree

    wget
    curl
    dig
  ];

  home = {
    file = {
      "${config.xdg.configHome}/wget/wgetrc" = {
        enable = true;
        text = "";
      };
    };
    sessionVariables = {
      WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
    };
  };
}
