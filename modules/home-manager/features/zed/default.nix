{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      ruff
      pyright
    ];
    extensions = [
      "html"
      "nix"
      "sql"
      "toml"
      "env"
      "csv"
      "make"
      "dockerfile"
      "docker-compose"
      "helm"
      "rego"
      "csharp"
      "golangci-lint"
      "go-snippets"
      "gosum"
    ];
    userSettings = {
      auto_update = false;
      base_keymap = "JetBrains";
      theme = {
        mode = "system";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
      vim_mode = true;
      vim = {
        use_system_clipboard = "always";
      };
      ui_font_family = "Cantarell";
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Hack Nerd Font";
      buffer_font_features = {
        calt = false;
        liga = false;
      };
      format_on_save = "on";
      file_types = {
        Dockerfile = ["Dockerfile" "Dockerfile.*"];
      };
      git = {
        inline_blame = {
          enabled = false;
        };
      };
      calls = {
        mute_on_join = true;
        share_on_join = false;
      };
      languages = {
        Nix = {
          language_servers = [
            "nil"
            "!nixd"
          ];
          formatter = {
            external = {
              command = "alejandra";
            };
          };
        };
        Python = {
          format_on_save = "on";
          language_servers = ["pyright" "ruff"];
          formater = [
            {
              code_actions = {
                source.fixAll.ruff = true;
                source.organizeImports.ruff = true;
              };
            }
          ];
        };
      };
      lsp = {
        ruff = {
          initialization_options = {
            settings = {
              lineLength = 120;
            };
          };
        };
      };
    };
  };
}
