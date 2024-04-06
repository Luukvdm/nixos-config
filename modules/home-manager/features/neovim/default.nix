{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # I would like to have the neovim config in the nixos modules.
  # But I can't get the nixpkgs overwrite to work :(.
  imports = [
    # overwrite nixpkgs with unstable branch
    ({...} @ args: (inputs.nixvim.homeManagerModules.nixvim (args // {pkgs = pkgs.unstable;})))

    ./cmp.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
    ./none-ls.nix

    ./keymaps.nix

    ./langs/go.nix
  ];

  home = {
    shellAliases = {
      vim = "nvim ";
    };
  };

  programs.nixvim = {
    enable = true;
    globals.mapleader = "\\";
    clipboard.providers.wl-copy.enable = true;

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
      updatetime = 300;
      writebackup = false;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      number = true;
      wrap = false;
      background = "dark";
    };

    colorschemes.gruvbox.enable = true;
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
      # lspsaga.enable = true;
      nvim-tree = {
        enable = true;
      };
      nix = {
        enable = true;
      };
      nix-develop = {
        enable = true;
      };
    };

    extraPackages = with pkgs.unstable; [
      gawk # trim_whitespace
      alejandra
    ];
  };
}
