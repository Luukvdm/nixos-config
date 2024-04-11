{
  pkgs,
  config,
  lib,
  ...
}: let
  gocfg = config.myHomeManager.go;
  cfg = config.myHomeManager.neovim.go;
in {
  options.myHomeManager.neovim.go = {
    enable = lib.mkOption {
      default = gocfg.enable;
      example = true;
      description = "Whether to enable the Neovim Golang config.";
      type = lib.types.bool;
    };
    goPackage = lib.mkOption {
      type = lib.types.package;
      default = gocfg.package;
      description = "The Go package to use.";
    };
    gotoolsPackage = lib.mkOption {
      type = lib.types.package;
      default = gocfg.gotoolsPackage;
      description = "The gotools package to use.";
    };
    gofumptPackage = lib.mkOption {
      type = lib.types.package;
      default = gocfg.gofumptPackage;
      description = "The gofumpt package to use.";
    };
    goimportsRevisorPackage = lib.mkOption {
      type = lib.types.package;
      default = gocfg.importsRevisorPackage;
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
