{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = false;
    enableIonIntegration = false;
    enableNushellIntegration = false;

    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;

      # format = lib.concatStrings [
      #   # "(color_yellow)"
      #   "$username"
      #   "(color_yellow)"
      #   "$directory"
      #   "[](bg:color_orange fg:color_yellow)"
      #   "$git_branch"
      #   "$git_status"
      #   "[](bg:color_aqua fg:color_orange)"
      #   "$direnv"
      #   "$nix_shell"
      #   "$docker_context"
      #   "$kubernetes"
      #   "[](bg:color_blue fg:color_aqua)"
      #   "$git_state"
      #   "[ ](fg:color_blue)"
      #   # "[](fg:color_bg3 bg:color_bg1)"
      # ];
      format = lib.concatStrings [
        # "(color_yellow)"
        "$username"
        "(color_blue)"
        "$nix_shell"
        "$directory"
        "[](bg:color_yellow fg:color_blue)"
        "$git_branch"
        "$git_status"
        "[](fg:color_yellow)"
        "$direnv"
        "$docker_context"
        "$kubernetes"
        # "[](bg:color_blue fg:color_aqua)"
        "$git_state"
        " "
        # "[ ](fg:color_blue)"
        # "[](fg:color_bg3 bg:color_bg1)"
      ];

      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_fg1 = "#282828";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        # color_blue = "#458588";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        # color_yellow = "#d79921";
        color_yellow = "#D79921";
        color_black = "#000000";
      };

      directory = {
        style = "bg:color_blue fg:color_fg1";
        # read_only_style = "bg:color_red fg:color_fg0";
        format = "[$read_only $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        truncate_to_repo = false;
        read_only = "🗝";
      };

      username = {
        style_root = "bg:color_orange fg:color_blue";
        style_user = "";
        format = "[$user]($style)[]";
      };
      hostname = {
        ssh_only = true;
      };

      git_branch = {
        symbol = "";
        style = "bg:color_yellow fg:color_black";
        format = "[ $symbol $branch ]($style)";
      };
      git_status = {
        style = "bg:color_yellow fg:color_black";
        format = "[$all_status$ahead_behind ]($style)";
      };
      git_state = {
        style = "bg:color_blue fg:color_fg0";
        format = "([$state( $progress_current/$progress_total)]($style)) ";
      };

      nix_shell = {
        format = "$symbol($style) ";
      };
      direnv = {
        disabled = true; # TODO
        format = "[$symbol$loaded/$allowed]($style) ";
      };
      kubernetes = {
        disabled = true; # TODO
        symbol = "☸ ";
        format = "[$symbol$context]($style) in ";
      };
    };
  };
}
