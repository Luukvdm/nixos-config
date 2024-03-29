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
      tf = "terraform ";
    };

    systemPackages = with pkgs; [
      terraform
      terraform-ls
      terraform-lsp
      terraform-docs
    ];
  };
}
