{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim

    ./cmp.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
    ./none-ls.nix

    ./keymaps.nix

    ./langs/go.nix
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    globals.mapleader = "\\";

    opts = {
      conceallevel = 0;
      fileencoding = "utf-8";
      ignorecase = true;
      showmode = true;
      showtabline = 2;
      smartcase = true;
      smartindent = true;
      swapfile = false;
      termguicolors = true;
      undofile = true;
      updatetime = 100;
      writebackup = false;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
      relativenumber = true;
      wrap = false;
      background = "dark";

      completeopt = ["menu" "menuone" "noselect"]; # For CMP plugin
    };

    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    editorconfig = {
      enable = true;
    };

    plugins = {
      direnv = {
        enable = true;
      };
      gitsigns = {
        enable = true;
      };
      web-devicons = {
        enable = true;
      };
      # lspsaga.enable = true;
      nvim-tree = {
        enable = true;
        autoReloadOnWrite = true;
      };
      nix = {
        enable = true;
      };
      nix-develop = {
        enable = true;
      };
    };

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      gawk # trim_whitespace
      alejandra
    ];
  };
}
