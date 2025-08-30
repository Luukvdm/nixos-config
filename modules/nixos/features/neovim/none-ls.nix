{
  config,
  lib,
  ...
}: let
  cfg = config.myNixOS.neovim;
in {
  options.myNixOS.neovim = {
    enableNoneLs = lib.mkOption {
      # default = gocfg.enable;
      default = false;
      example = true;
      description = "Whether to enable None-LS.";
      type = lib.types.bool;
    };
  };

  config.programs.nixvim = {
    plugins = {
      lsp.servers.nil_ls.enable = false;
      none-ls = {
        enable = cfg.enableNoneLs;
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
            d2_fmt.enable = true;
            pg_format.enable = true;
            rego.enable = false;
            yamlfmt = {
              enable = true;
              # settings = {
              #   extra_args = [
              #     "-formatter"
              #     "retain_line_breaks_single=true,trim_trailing_whitespace=true"
              #   ];
              # };
            };
          };
          hover = {};
        };
      };
    };
  };
}
