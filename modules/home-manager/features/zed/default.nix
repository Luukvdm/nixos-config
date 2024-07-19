{
  pkgs,
  config,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    zed-editor
  ];

  xdg.configFile.settings.json = {
    enable = true;
    target = "zed";
    text = ''
      // documentation: https://zed.dev/docs/configuring-zed
      {
        "base_keymap": "JetBrains",
        "theme": "Gruvbox Dark Hard",
        "telemetry": {
          "metrics": false,
          "diagnostics": false
        },
        "vim_mode": true,
        "ui_font_size": 16,
        "buffer_font_size": 16,
        "buffer_font_family": "Hack Nerd Font",
        "buffer_font_features": {
          "calt": false,
          "liga": false
        },
        "file_types": {
          "Dockerfile": ["Dockerfile", "Dockerfile.*"]
        }
      }
    '';
  };
}
