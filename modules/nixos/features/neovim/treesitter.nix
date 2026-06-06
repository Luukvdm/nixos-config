{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myNixOS.neovim;
in {
  options.myNixOS.neovim = {
    enableTreesitter = lib.mkOption {
      # default = gocfg.enable;
      default = true;
      example = true;
      description = "Whether to enable Treesitter.";
      type = lib.types.bool;
    };
  };

  config.programs.nixvim = lib.mkIf cfg.enableTreesitter {
    plugins = {
      treesitter = {
        enable = cfg.enableTreesitter;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };

        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          awk
          bash
          # c_sharp
          css
          csv
          desktop
          dockerfile
          editorconfig
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          gomod
          gosum
          gotmpl
          gowork
          helm
          html
          # htmldjango
          http
          java
          javascript
          jq
          json
          make
          markdown
          markdown_inline
          pem
          properties
          proto
          python
          regex
          rego
          # rust
          sql
          ssh_config
          terraform
          toml
          typescript
          vue
          yaml
          zsh
        ];
      };
      treesitter-context = {
        enable = true;
        settings = {
          enable = true;
        };
      };
    };
  };
}
