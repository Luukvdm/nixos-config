# aws configure list-profiles | fzf
{
  config,
  lib,
  pkgs,
  options,
  username,
  ...
}: let
  cfg = config.myNixOS.cloud;

  awsSso = pkgs.writeScriptBin "aws-sso" ''
    if (($# != 1))
    then
        echo "no session given, use like 'aws-sso MySession'"
    else
        aws sso login --sso-session "$@"
    fi
  '';
in {
  options.myNixOS.cloud = {
    user = lib.mkOption {
      type = with lib.types; str;
      default = username;
      description = ''
        Wether to include a GUI for ClamAV.
      '';
    };
  };

  environment = {
    shellAliases = {
      aws-profile = "export AWS_PROFILE=$(aws configure list-profiles | ${pkgs.fzf}/bin/fzf)";
    };
  };

  users.users."${cfg.user}" = {
    packages = with pkgs; [
      azure-cli
      awscli2
      (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
        gcloud-man-pages
        cloud-run-proxy
      ]))
      hcloud

      awsSso
    ];
  };
}
