{
  pkgs,
  system,
  stdenv,
  cmake,
  ninja,
  lib,
}: let
  version = "0.15.0";
in
  stdenv.mkDerivation {
    pname = "rs-bolt";
    version = version;
    src = pkgs.fetchFromGitHub {
      owner = "Adamcake";
      repo = "Bolt";
      rev = version;
      #   sha256 = "sha256-GBvs8up/rIGPcJCbf/26YZ/mrwqzZ8pUYUnZnmqeV6U";
      sha256 = "sha256-2IoFzD+yhQv1Y7D+abeNUT23BC4P1xZTALF8Y+Zsg44=";

      fetchSubmodules = true;
    };

    nativeBuildInputs = [cmake];
    buildInputs = [pkgs.xorg.libX11 pkgs.xorg.libxcb pkgs.libarchive pkgs.luajit pkgs.gcc pkgs.libgcc pkgs.cmake];

    cmakeFlags = ["-DCMAKE_BUILD_TYPE=Release"]; # "-DCMAKE_PREFIX_PATH=${pkgs.libcef}/lib:CMAKE_PREFIX_PATH"];

    preConfigure = ''
      echo pre configure
      # export CMAKE_PREFIX_PATH="${pkgs.libcef}/lib:$CMAKE_PREFIX_PATH"
      export BOLT_LIBCEF_DIRECTORY=${pkgs.libcef}/lib
      mkdir -p cef
      ln -s ${pkgs.libcef}/lib cef/dist
      ls cef/dist
    '';

    dontUseCmakeConfigure = true;

    # buildPhase = ''
    #   runHook preBuild

    #   cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
    #   cmake --build build
    #   cmake --install build --prefix build
    #   tree

    #   runHook postBuild
    # '';
    # installPhase = ''
    #   cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
    #   cmake --build build
    #   cmake --install build --prefix build
    # '';

    meta = {
      description = "";
      homepage = "https://github.com/Adamcake/Bolt";
      #   license = lib.licenses.; #  AGPL-3.0 license
      maintainers = [];
      platforms = lib.platforms.linux;
      #   mainProgram = "ttyd";
    };
  }
