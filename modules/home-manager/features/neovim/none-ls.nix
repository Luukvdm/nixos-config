{...}: {
  programs.nixvim = {
    plugins = {
      none-ls = {
        enable = true;
        # onAttach = ''
        #   function(client, bufnr)
        #       if client.supports_method "textDocument/formatting" then
        #         vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        #         vim.api.nvim_create_autocmd("BufWritePre", {
        #           group = augroup,
        #           buffer = bufnr,
        #           callback = function()
        #             vim.lsp.buf.format ({ bufnr = bufnr })
        #           end,
        #         })
        #       end
        #     end
        # '';
        sources = {
          code_actions = {
            gitsigns.enable = true;
          };
          completion = {};
          diagnostics = {
            buf.enable = true;
            golangci_lint.enable = true;
            zsh.enable = true;
          };
          formatting = {
            alejandra.enable = true;
            black.enable = true;
            # d2_fmt.enable = true;
            pg_format.enable = true;
            rego.enable = true;
            yamlfmt.enable = true;
          };
          hover = {};
        };
      };
    };
  };
}
