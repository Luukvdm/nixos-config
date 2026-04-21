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
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };
      };
      # treesitter-context = {
      # enable = true;
      # };
    };
  };
}
