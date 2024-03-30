{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      telescope = {
        enable = true;
        defaults = {
          file_ignore_patterns = ["node_modules" "venv" "bin" "obj" ".idea" "vendor"];
        };
        keymaps = {
          "<Leader><Space>" = {
            action = "git_files";
            desc = "Telescope Git Files";
          };
          "<Leader>f" = {
            action = "find_files";
            desc = "Telescope Find Files";
          };
          "<Leader>g" = {
            action = "live_grep";
            desc = "Telescope Live Grep";
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
