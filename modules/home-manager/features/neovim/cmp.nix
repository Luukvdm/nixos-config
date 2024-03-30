{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-path.enable = true;
      cmp-treesitter.enable = true;
      cmp-vsnip.enable = true;
      cmp-zsh.enable = true;
    };
  };
}
