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
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = with pkgs.vscode-extensions;
        [
          vscodevim.vim
          kamadorueda.alejandra
          bbenoist.nix
          editorconfig.editorconfig
          mkhl.direnv
          jdinhlife.gruvbox

          # go
          golang.go

          # python
          ms-python.python
          ms-python.debugpy
          ms-pyright.pyright

          # java
          redhat.java
        ]
        ++ (with pkgs.unstable; [
          charliermarsh.ruff
        ]);
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      userSettings = {
        "update.mode" = "none";

        "window.zoomLevel" = 0.5;
        "workbench.colorTheme" = "Gruvbox Dark Medium";

        "editor.fontFamily" = "'Hack', 'Droid Sans Mono', 'monospace'";
        "editor.minimap.enabled" = false;
        "editor.minimap.autohide" = true;

        "files.exclude" = {
          "**/.direnv" = true;
          "**/.devenv" = true;

          "node_modules/" = true;
          "out/" = true;
          "vendor/" = true;
          "**/__pycache__" = true;
          "**/*.egg-info" = true;
        };

        "terminal.integrated.tabs.enabled" = true;

        "telemetry.telemetryLevel" = "off";

        "dotnet.server.useOmnisharp" = true;
        "[csharp]" = {
          "editor.defaultFormatter" = "ms-dotnettools.csharp";
          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.formatOnType" = false;
        };
      };
    };
  };
}
