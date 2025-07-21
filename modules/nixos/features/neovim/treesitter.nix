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

  config.programs.nixvim = {
    plugins = {
      treesitter = {
        enable = cfg.enableTreesitter;
        nixvimInjections = true;
        # folding = true;

        settings = {
          indent = {
            enable = true;
          };
          ensureInstalled = [
            "bash"
            "css"
            "dockerfile"
            "go"
            "gomod"
            "html"
            "javascript"
            "markdown"
            "python"
            "vue"
            "yaml"
          ];
        };
      };
      # treesitter-context = {
      # enable = true;
      # };
    };
  };
}
