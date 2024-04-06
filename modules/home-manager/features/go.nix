{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.go;
in {
  options.myHomeManager.go = {
    package = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.go_1_22;
      description = "The Go package to use.";
    };
    gotoolsPackage = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.gotools;
      description = "The gotools package to use.";
    };
    gofumptPackage = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.gofumpt;
      description = "The gotools package to use.";
    };
    includeGoland = lib.mkOption {
      type = with lib.types; bool;
      default = false;
      description = ''
        Wether to include Jetbrains Goland.
      '';
    };
  };

  programs.go = {
    enable = true;
    package = cfg.package;
    goPath = ".local/share/go";
    goBin = ".local/share/go/bin";
    goPrivate = ["gitlab.com/suecode"];
    # packages = {
    #   "golang.org/x/tools/cmd/goimports" = builtins.fetchGit "https://go.googlesource.com/tools";
    #   "golang.org/x/tools/cmd/fiximports" = builtins.fetchGit "https://go.googlesource.com/tools";
    #   "golang.org/x/tools/cmd/godoc" = builtins.fetchGit "https://go.googlesource.com/tools";
    #  "gost.tools/gotestsum" = builtins.fetchGit "https://github.com/gotestyourself/gotestsum";
    #  "mvn.cc/gofumpt" = builtins.fetchGit "https://github.com/mvdan/gofumpt";
    # };
  };

  home.packages =
    [
      pkgs.unstable.delve
      cfg.gotoolsPackage
      cfg.gofumptPackage
    ]
    ++ lib.optionals cfg.includeGoland [
      pkgs.jetbrains-toolbox
      pkgs.jetbrains.goland
    ];
}
