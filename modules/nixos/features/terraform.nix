{
  config,
  lib,
  pkgs,
  ...
}: {
  environment = {
    sessionVariables = {
      TF_CLI_CONFIG_FILE = "$XDG_CONFIG_HOME/terraform/terraformrc";
    };

    shellAliases = {
      tf = "tofu";
    };

    systemPackages = with pkgs; [
      opentofu
      terraform-ls
      terraform-lsp
      terraform-docs
    ];
  };
}
