{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    tilix
  ];

  dconf.settings = {
    # https://github.com/gnunn1/tilix/blob/master/data/gsettings/com.gexperts.Tilix.gschema.xml
    "com/gexperts/Tilix" = {
      tab-position = "top";
      terminal-title-show-when-single = false;
      terminal-title-style = "normal";
      theme-variant = "dark";
      unsafe-paste-alert = false;
      use-tabs = true;
      window-style = "normal";
    };
    "com/gexperts/Tilix/keybindings" = {};
    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      visible-name = "Default";
      font = "Hack Nerd Font Mono 12";
      use-system-font = false;
      terminal-bell = "icon";
      bold-color-set = false;
      highlight-colors-set = false;
      use-theme-colors = false;
      background-color = "#282828";
      foreground-color = "#EBDBB2";
      cursor-colors-set = false;
      # cursor-background-color = "";
      # cursor-foreground-color = "#EBDBB2";
      palette = [
        "#282828"
        "#CC241D"
        "#98971A"
        "#D79921"
        "#458588"
        "#B16286"
        "#689D6A"
        "#A89984"
        "#928374"
        "#FB4934"
        "#B8BB26"
        "#FABD2F"
        "#83A598"
        "#D3869B"
        "#8EC07C"
        "#EBDBB2"
      ];
    };
  };
}
