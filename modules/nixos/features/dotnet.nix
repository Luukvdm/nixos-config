{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.dotnet;

  dotnetPkg = with pkgs; (with dotnetCorePackages;
    combinePackages [
      dotnet-sdk_8
      dotnet-runtime_8
      dotnet-aspnetcore_8
    ]);
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
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
      DOTNET_ROOT = "${dotnetPkg}";

      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      DOTNET_CLI_HOME = "$XDG_CONFIG_HOME/dotnet";
    };

    systemPackages = with pkgs;
      [
        dotnetPkg

        msbuild
        dotnetPackages.Nuget
        netcoredbg
        fsautocomplete
        roslyn
        omnisharp-roslyn
        roslyn-ls
        csharp-ls

        vscode-extensions.ms-dotnettools.csharp
      ]
      ++ lib.optionals cfg.includeRider [
        jetbrains-toolbox
        jetbrainsider
      ];
  };
}
