{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      telescope = {
        enable = true;
        settings = {
          defaults = {
            file_ignore_patterns = ["node_modules" "venv" "bin" "obj" ".idea" "vendor"];
          };
        };
        keymaps = {
          "<Leader><Space>" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<Leader>f" = {
            action = "find_files";
            options = {
              desc = "Telescope Find Files";
            };
          };
          "<Leader>g" = {
            action = "live_grep";
            options = {
              desc = "Telescope Live Grep";
            };
          };
        };
        keymapsSilent = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
      };
    };
  };
}
