{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = [
    pkgs.unstable.zed-editor
  ];

  xdg.configFile."zed/settings.json" = {
    enable = true;
    text = ''
      // documentation: https://zed.dev/docs/configuring-zed
      {
        "auto_update": false,
        "base_keymap": "JetBrains",
        "theme": {
          "mode": "system",
          "dark": "Gruvbox Dark",
          "light": "Gruvbox Light"
        },
        "telemetry": {
          "metrics": false,
          "diagnostics": false
        },
        "vim_mode": true,
        "ui_font_family": "Cantarell",
        "ui_font_size": 16,
        "buffer_font_size": 16,
        "buffer_font_family": "Hack Nerd Font",
        "buffer_font_features": {
          "calt": false,
          "liga": false
        },
        "file_types": {
          "Dockerfile": ["Dockerfile", "Dockerfile.*"]
        },
        "git": {
          "inline_blame": {
            "enabled": false
          }
        },
        "calls": {
          "mute_on_join": true,
          "share_on_join": false
        }
      }
    '';
  };

  xdg.dataFile = let
    nodeVersion = "node-v18.15.0-linux-x64";
    nodePackage = pkgs.nodejs_18;
  in {
    # Adding different directories one by one, as Zed wants to write to the "./cache" dir
    "zed/node/${nodeVersion}/bin".source = "${nodePackage}/bin";
    "zed/node/${nodeVersion}/include".source = "${nodePackage}/include";
    "zed/node/${nodeVersion}/lib".source = "${nodePackage}/lib";
    "zed/node/${nodeVersion}/share".source = "${nodePackage}/share";
  };
}
