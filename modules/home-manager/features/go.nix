{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.go;
in {
  options.myHomeManager.go = {
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
    package = pkgs.unstable.go_1_22;
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

  home.packages = with pkgs;
    [
      delve
    ]
    ++ lib.optionals cfg.includeGoland [
      jetbrains-toolbox
      jetbrains.goland
    ];
}
