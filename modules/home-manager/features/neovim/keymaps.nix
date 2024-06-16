{
  pkgs,
  config,
  ...
}: let
  helpers = config.nixvim.helpers;
in {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>NvimTreeToggle<CR>";
        key = "<Leader>t";
        mode = [
          "n"
        ];
        options = {
          silent = true;
          noremap = true;
        };
      }
      # Disable arrow keys in normal mode
      {
        mode = "n";
        key = "<left>";
        action = "<cmd>echo \"Use h to move!!\"<CR>";
      }
      {
        mode = "n";
        key = "<right>";
        action = "<cmd>echo \"Use l to move!!\"<CR>";
      }
      {
        mode = "n";
        key = "<up>";
        action = "<cmd>echo \"Use k to move!!\"<CR>";
      }
      {
        mode = "n";
        key = "<down>";
        action = "<cmd>echo \"Use j to move!!\"<CR>";
      }

      # {
      #   mode = "n";
      #   key = "gD";
      #   lua = true;
      #   action = helpers.mkRaw "vim.lsp.buf.declaration";
      #   options = {desc = "[G]oto [D]eclaration";};
      # }

      # Rename the variable under your cursor
      #  Most Language Servers support renaming across files, etc.
      # {
      #   mode = "n";
      #   key = "<leader>rn";
      #   lua = true;
      #   action = helpers.mkRaw "vim.lsp.buf.rename";
      #   options = {desc = "[R]e[n]ame";};
      # }
    ];
  };
}
