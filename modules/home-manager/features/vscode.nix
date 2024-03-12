{
  pkgs,
  config,
  lib,
  ...
}: {
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
