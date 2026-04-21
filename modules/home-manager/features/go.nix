{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.go;

  # https://github.com/NixOS/nixpkgs/issues/509480
  gotoolsWithoutModernize = pkgs.symlinkJoin {
    name = "gotools-without-modernize";
    paths = [pkgs.unstable.gotools];
    postBuild = ''
      rm -f "$out/bin/modernize"
    '';
  };
in {
  options.myHomeManager.go = {
    package = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.go_1_26;
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
    golangCiLintPackage = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.golangci-lint;
      description = "The golangci-lint package to use.";
    };
    importsRevisorPackage = lib.mkOption {
      type = with lib.types; types.package;
      default = pkgs.unstable.goimports-reviser;
      description = "The package to use for goimports-reviser";
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
    env = let
      inherit (config.home) homeDirectory;
    in {
      GOPRIVATE = ["gitlab.com/suecode"];
      GOBIN = "${homeDirectory}/.local/share/go/bin";
      GOPATH = "${homeDirectory}/.local/share/go";
    };
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
      pkgs.unstable.goperf
      pkgs.unstable.gopls
      cfg.golangCiLintPackage
      # cfg.gotoolsPackage
      gotoolsWithoutModernize
      cfg.gofumptPackage
      cfg.importsRevisorPackage
    ]
    ++ lib.optionals cfg.includeGoland [
      pkgs.unstable.jetbrains-toolbox
      pkgs.unstable.jetbrains.goland
    ];
}
