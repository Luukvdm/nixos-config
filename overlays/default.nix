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
      system = final.stdenv.hostPlatform.system;
      buildPlatform = final.stdenv.buildPlatform.system; # "x86_64-linux";
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
