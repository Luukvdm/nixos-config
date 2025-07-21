{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.neovim;
in {
  options.myNixOS.neovim = {
    enableLsp = lib.mkOption {
      # default = gocfg.enable;
      default = true;
      example = true;
      description = "Whether to enable LSP.";
      type = lib.types.bool;
    };
  };

  config.programs.nixvim = {
    plugins = {
      lsp = {
        enable = cfg.enableLsp;
        # onAttach
        servers = {
          bashls.enable = true;
          dockerls.enable = true;
          golangci_lint_ls.enable = true;
          gopls = {
            enable = true;
            extraOptions = {
              analyses = {
                unusedparams = true;
                shadow = true;
              };
            };
          };
          helm_ls.enable = true;
          jsonls.enable = true;
          marksman.enable = true;
          pylsp.enable = true;
          terraformls.enable = true;
          volar = {
            enable = true;
            filetypes = ["typescript" "javascript" "javascriptreact" "typescriptreact" "vue"];
          };
          yamlls = {
            enable = true;
            # onAttach = ''
            #   function(client, bufnr)
            #     if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype == "helm" then
            #         vim.diagnostic.disable()
            #     end
            #   end
            # '';
          };
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      lsp-lines = {
        enable = true;
      };
    };
  };
}
