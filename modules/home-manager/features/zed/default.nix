{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [
      alejandra

      ruff
      ty
      pyright
      djlint

      jdk
      jdt-language-server
      maven

      claude-code
    ];
    extensions = [
      "nix"
      "html"
      "toml"

      "sql"
      "env"
      "csv"
      "make"
      "dockerfile"
      "docker-compose"
      "terraform"
      "helm"
      "rego"
      "csharp"
      "java"
      "golangci-lint"
      "go-snippets"
      "gosum"
      "powershell"
      "xml"
    ];
    userSettings = {
      auto_update = false;
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      vim_mode = true;
      vim = {
        use_system_clipboard = "always";
      };
      base_keymap = "JetBrains";
      format_on_save = "on";

      theme = {
        mode = "system";
        dark = "Gruvbox Dark";
        light = "Gruvbox Light";
      };
      ui_font_family = "Cantarell";
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Hack Nerd Font";
      buffer_font_features = {
        calt = false;
        liga = false;
      };

      load_direnv = "shell_hook";
      git = {
        inline_blame = {
          enabled = false;
        };
      };
      calls = {
        mute_on_join = true;
        share_on_join = false;
      };

      # Replaces the defaults rather than extending them, so they are restated here
      file_scan_exclusions = [
        # Zed defaults
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/.jj"
        "**/.sl"
        "**/.repo"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"

        # Java/Maven
        "**/target"
        "**/.project"
        "**/.factorypath"

        # Dotnet
        "**/bin"
        "**/obj"
        "**/.vs"
        "**/packages"
        "**/*.dll"
        "**/*.exe"

        "**/node_modules"
        "**/*.zip"
        "**/*.diff"
      ];

      file_types = {
        Dockerfile = ["Dockerfile" "Dockerfile.*"];
        XML = ["csproj" "wixproj"];
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
          format_on_save = "on";
        };
        Python = {
          format_on_save = "on";
          language_servers = ["pyright" "ruff" "ty"];
          formatter = [
            {
              code_actions = {
                source.fixAll.ruff = true;
                source.organizeImports.ruff = true;
              };
            }
            {language_server = {name = "ruff";};}
          ];
        };
        HTML = {
          language_servers = ["vscode-html-language-server"];
          format_on_save = "on";
        };
        CSS = {
          language_servers = ["vscode-css-language-server"];
          format_on_save = "on";
        };
        Java = {
          language_servers = ["jdtls"];
          format_on_save = "on";
        };
      };
      # Null these so the store paths are cleared from the mutable settings file.
      # They get pushed to remote servers, where node resolution hard-fails on a
      # nonexistent path. Unset means PATH lookup: nixpkgs wraps Zed with nodejs
      # locally, and remote hosts resolve their own.
      node = {
        path = null;
        npm_path = null;
      };
      lsp = {
        nix = {
        };
        nil = {
          binary = {
            path = "${pkgs.nil}/bin/nil";
          };
        };
        ruff = {
          binary = {
            path = "${pkgs.ruff}/bin/ruff";
            arguments = ["server"];
          };
          initialization_options = {
            settings = {
              # lineLength = 120;
            };
          };
        };
        ty = {
          binary = {
            path = "${pkgs.ty}/bin/ty";
            arguments = ["server"];
          };
        };
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic";
              };
            };
          };
        };
        vscode-html-language-server.binary = {
          path = "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server";
          arguments = ["--stdio"];
        };
        vscode-css-language-server = {
          binary = {
            path = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            arguments = ["--stdio"];
          };
        };
        jdtls = {
          binary = {
            path = "${pkgs.jdt-language-server}/bin/jdtls";
          };
          settings = {
            # Passed through to jdtls as initializationOptions
            initialization_options = {
              settings = {
                java = {
                  configuration = {
                    # Re-import the pom on change, else the classpath goes stale
                    updateBuildConfiguration = "automatic";
                    runtimes = [
                      {
                        name = "JavaSE-21";
                        path = "${pkgs.jdk.home}";
                        default = true;
                      }
                    ];
                  };
                  import = {
                    maven = {
                      enabled = true;
                    };
                  };
                  completion = {
                    favoriteStaticMembers = [
                      "org.junit.jupiter.api.Assertions.*"
                      "org.junit.jupiter.api.Assumptions.*"
                      "org.mockito.Mockito.*"
                    ];
                    importOrder = ["java" "javax" "com" "org"];
                  };
                };
              };
            };
          };
        };
        omnisharp = {
          # Omit binary path so it functions when using a remote project
          # binary = {
          #   path = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
          # };
          settings = {
            dotnet = {
              useModernNet = false;
            };
          };
        };
      };
      agent = {
        default_model = {
          provider = "anthropic";
          # model = "claude-3-5-sonnet-latest";
        };
      };
    };
  };
}
