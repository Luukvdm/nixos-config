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
      editorconfig.editorconfig
      mkhl.direnv
      ms-dotnettools.csharp
    ];

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = {
      update.mode = "none";

      "files.exclude" = {
        # removes these from the search
        "**/.direnv" = true;
        "**/.devenv" = true;
      };
    };
  };
}
