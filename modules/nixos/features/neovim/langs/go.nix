{
  pkgs,
  config,
  lib,
  ...
}: let
  # gocfg = config.myNixOS.go;
  cfg = config.myNixOS.neovim.go;
in {
  options.myNixOS.neovim.go = {
    enable = lib.mkOption {
      # default = gocfg.enable;
      default = true;
      example = true;
      description = "Whether to enable the Neovim Golang config.";
      type = lib.types.bool;
    };
    goPackage = lib.mkOption {
      type = lib.types.package;
      # default = gocfg.package;
      default = pkgs.unstable.go_1_24;
      description = "The Go package to use.";
    };
    gotoolsPackage = lib.mkOption {
      type = lib.types.package;
      # default = gocfg.gotoolsPackage;
      default = pkgs.unstable.gotools;
      description = "The gotools package to use.";
    };
    gofumptPackage = lib.mkOption {
      type = lib.types.package;
      # default = gocfg.gofumptPackage;
      default = pkgs.unstable.gofumpt;
      description = "The gofumpt package to use.";
    };
    goimportsRevisorPackage = lib.mkOption {
      type = lib.types.package;
      # default = gocfg.importsRevisorPackage;
      default = pkgs.unstable.goimports-reviser;
      description = "The goimports-reviser package to use.";
    };
  };

  config = {
    programs.nixvim = {
      extraPlugins = with pkgs.unstable.vimPlugins; [
        go-nvim
      ];

      extraConfigLua = "require('go').setup()";

      autoCmd = [
        {
          event = ["BufWritePre"];
          pattern = ["*.go"];
          callback = "require('go.format').goimports()";
          # group = "format_sync_grp";
        }
      ];

      plugins = {
        none-ls = {
          sources = {
            formatting = {
              gofmt = {
                enable = true;
                package = cfg.goPackage;
              };
              gofumpt = {
                enable = true;
                package = cfg.gofumptPackage;
              };
              goimports = {
                enable = true;
                package = cfg.gotoolsPackage;
              };
              goimports_reviser = {
                enable = true;
                package = cfg.goimportsRevisorPackage;
              };
            };
          };
        };
      };
    };
  };
}
