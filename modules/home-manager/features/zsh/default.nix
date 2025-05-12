{
  pkgs,
  config,
  lib,
  username,
  ...
}: {
  home.packages = with pkgs; [
    powerline
    powerline-symbols
  ];

  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    # history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    # enableFzfCompletion = true;
    # enableFzfGit = true;
    # enableFzfHistory = true;
    enableVteIntegration = true;
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
    completionInit = ''
      zstyle ':completion:*:*:docker:*' option-stacking yes
      zstyle ':completion:*:*:docker-*:*' option-stacking yes

      autoload -U compinit

      _dotnet_zsh_complete()
      {
        local completions=("$(dotnet complete "$words")")
        reply=( "$${(ps:\n:)completions}" )
      }
      compctl -K _dotnet_zsh_complete dotnet
    '';
    sessionVariables = {
    };
    envExtra = ''
      # export DEFAULT_USER=$\{username};
      export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$XDG_DATA_HOME/go/bin:$XDG_CONFIG_HOME/dotnet/.dotnet/tools:$PATH";

      # this should probably be in profile
      color='\033[38;5;220m\]'
      hostnameColor='\033[38;5;214m\]'
      if [ $(id -u) -eq 0 ]; then # root
        color='\033[38;5;214m\]'
      fi

      bindkey "\033[1~" beginning-of-line
      bindkey "\033[4~" end-of-line

      autoload -U colors && colors
      PS1="%B %{$fg[green]%}%~%{$reset_color%}%b "
    '';
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      sudo = "sudo ";
      ls = "ls --color=auto";
      # ..="cd ..";
      df = "df -h";
      du = "du -ch";
      ipp = "curl ipinfo.io/ip";
      ip = "ip -c";
      cp = "cp -iv";
      mv = "mv -iv";
      srm = "rm -vI";
      open = "xdg-open";
      grep = "grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}";
      f = "$FILE";
      e = "$EDITOR";
      service = "${pkgs.systemd}/bin/systemctl";
      userctl = "${pkgs.systemd}/bin/systemctl --user";
      restart = "service restart";
      status = "${pkgs.systemd}/bin/systemctl status";
      errors = "${pkgs.systemd}/bin/journalctl -p err..alert --since '24 h ago'";
      cat = "bat --paging=never";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = ["git" "golang" "python" "npm" "node" "man" "history" "docker" "docker-compose" "kubectl" "helm"];
    # theme = "gruvbox";
    #  custom = "${config.xdg.configHome}/oh-my-zsh/custom";
    # custom = builtins.toPath ./omz-custom;
    # customPkgs = with pkgs; [
    #   nix-zsh-completions
    #   # and even more...
    # ];
  };
  # xdg.configFile.".config/oh-my-zsh/custom/" = {
  #   source = builtins.toPath ./. + "/omz-custom/";
  #   recursive = true;
  # };
}
