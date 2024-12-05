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
      DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
      DOTNET_ROOT = "${pkgs.dotnet-sdk_9}";

      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      DOTNET_CLI_HOME = "$XDG_CONFIG_HOME/dotnet";
    };

    systemPackages = with pkgs;
      [
        dotnet-sdk_9
        dotnet-runtime_9
        dotnet-aspnetcore_9

        # some of these use a deprecated dotnet version
        # msbuild
        dotnetPackages.Nuget
        # netcoredbg
        # fsautocomplete
        # roslyn
        omnisharp-roslyn
        # roslyn-ls
        # csharp-ls

        vscode-extensions.ms-dotnettools.csharp
      ]
      ++ lib.optionals cfg.includeRider [
        # uses deprecated dotnet version
        # jetbrains-toolbox
        # jetbrains.rider
      ];
  };
}
