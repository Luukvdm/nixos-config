{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.dotnet;
in {
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
        (
          with dotnetCorePackages;
            combinePackages [
              dotnet-aspnetcore_7
              dotnet-runtime_7
              dotnet-sdk_7

              dotnet-sdk_8
              dotnet-runtime_8
              dotnet-aspnetcore_8
            ]
        )
        dotnetPackages.Nuget
        netcoredbg
        omnisharp-roslyn
        fsautocomplete
        roslyn
        roslyn-ls

        vscode-extensions.ms-dotnettools.csharp
      ]
      ++ lib.optionals cfg.includeRider [
        jetbrains-toolbox
        jetbrainsider
      ];
  };
}
