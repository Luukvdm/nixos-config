{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHomeManager.git;
  homeCfg = config.home;
in {
  options.myHomeManager.git = {
    mainUserFile = lib.mkOption {
      type = with lib.types; either str path;
      description = ''
        git config for the primary user
      '';
    };
    extraIncludes = lib.mkOption {
      type = with lib.types; types.listOf types.attrs;
      default = [];
    };
  };

  home.shellAliases = {
    g = "git";
    gc = "git commit";
    gco = "git checkout";
    gs = "git status -sb";
    delete-merged = "git branch --merged | grep -v \* | xargs git branch -D";
  };

  programs = {
    difftastic = {
      enable = true;
      git = {
        enable = true;
      };
    };
    git = {
      includes =
        [
          {
            contentSuffix = "gituser";
            path = cfg.mainUserFile;
          }
        ]
        ++ cfg.extraIncludes;
      settings = {
        core = {
          editor = "nvim";
          sshCommand = "ssh";
        };
        # diff.tool = "difft --skip-unchanged";# "vimdiff";
        difftool.prompt = false;
        merge = {
          tool = "vimdiff";
          conflictstyle = "diff3";
        };
        web.browser = "firefox";
        http.sslverify = true;
        color.ui = true;
        credential.helper = "store";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull = {
          rebase = true;
          ff = "only";
        };
        url = {
          "git@gitlab.com:" = {
            insteadOf = "https://gitlab.com/";
          };
        };
        alias = {
          mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
          cob = "checkout -b ";
        };
      };
    };
  };
}
