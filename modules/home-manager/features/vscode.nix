{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    alejandra
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      kamadorueda.alejandra
      bbenoist.nix
    ];

    userSettings = {
      update.mode = "none";
    };
  };
}
