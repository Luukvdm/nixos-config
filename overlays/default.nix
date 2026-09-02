# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    vscode-extensions =
      prev.vscode-extensions
      // {
        vscjava =
          prev.vscode-extensions.vscjava
          // {
            # On activation, 0.59.0 mkdirs .noConfigDebugAdapterEndpoints inside its
            # own extension directory, which fails on a read-only store path. That
            # takes vscode-java-test down with it (hard extensionDependency), so no
            # tests are discovered. Upstream skips the mkdir when the directory
            # already exists, so pre-create it. Costs only no-config debugging.
            vscode-java-debug = prev.vscode-extensions.vscjava.vscode-java-debug.overrideAttrs (old: {
              postInstall =
                (old.postInstall or "")
                + ''
                  mkdir -p "$out/$installPrefix/.noConfigDebugAdapterEndpoints"
                '';
            });
          };
      };
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
  cross-packages = final: _prev: {
    cross = import inputs.nixpkgs {
      # system = final.stdenv.hostPlatform.system;
      # buildPlatform = "x86_64-linux"; # final.stdenv.buildPlatform.system;
      localSystem = "x86_64-linux"; # The machine doing the building
      crossSystem = final.stdenv.hostPlatform.system; # The target architecture
      config = {
        allowUnfree = true;
        allowUnfreePredicate = pkg:
          builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
            "ubootTuringRK1"
          ];
      };
    };
  };
}
