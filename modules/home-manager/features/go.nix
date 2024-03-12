{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.go = {
    enable = true;
    package = pkgs.go_1_22;
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
}
