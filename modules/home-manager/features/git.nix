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
    sueUserFile = lib.mkOption {
      type = with lib.types; either str path;
      description = ''
        git config for the sue user
      '';
    };
  };
  programs.git = {
    enable = true;
    aliases = {
      mr = "!sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -";
      cob = "checkout -b ";
    };
    includes = [
      {
        contentSuffix = "gituser";
        path = cfg.mainUserFile;
      }
      {
        condition = "gitdir:${homeCfg.homeDirectory}/code/sue/";
        path = cfg.sueUserFile;
      }
    ];
    extraConfig = {
      core.editor = "nvim";
      diff.tool = "vimdiff";
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
    };
  };
}
