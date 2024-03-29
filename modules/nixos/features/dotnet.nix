{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.dotnet = {
    includeRider = lib.mkOption {
      type = with lib.types; bool;
      default = false;
      description = ''
        Wether to include Jetbrains Rider.
      '';
    };
  };

  environment = {
    sessionVariables = {
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";

      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      DOTNET_CLI_HOME = "$XDG_CONFIG_HOME/dotnet";
    };

    systemPackages = with pkgs;
      [
        dotnet-sdk
        dotnet-runtime
      ]
      ++ lib.optionals cfg.includeGoland [
        jetbrains-toolbox
        jetbrainsider
      ];
  };
}
