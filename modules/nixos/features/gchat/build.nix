# TODO: Move into pkgs and fix status bar icon
{
  pkgs,
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  nodejs,
  electron,
  glib,
}: let
  version = "5.27.23-6";
  icon = "google-chat-linux";
  # _buildNpmPackage = buildNpmPackage.override { nodejs = nodejs; };
  desktopItem = makeDesktopItem {
    name = "Google Chat";
    inherit icon;
    exec = "google-chat-linux %U";
    comment = "Unofficial Google Chat Electron app";
    desktopName = "google-chat-linux";
    categories = ["Application"];
  };
  # electron = electron_24;
in
  buildNpmPackage rec {
    pname = "google-chat-linux";
    inherit version;
    src = fetchFromGitHub {
      owner = "squalou";
      repo = "google-chat-linux";
      rev = "${version}";
      hash = "sha256-N9ByEV50JmXSWMkYpIizmgLXV2pwvtduhcWTMp+XfqA=";
    };

    npmDepsHash = "sha256-KQdjy7oCyKa5GQabR5q4J5sNm8efKdODVcyVnYL6p4A=";
    npmBuildScript = "dist";
    buildInputs = [glib];
    nativeBuildInputs = [];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    buildPhase = ''
      runHook preBuild

      npm exec electron-builder -- \
        --dir \
        -c.electronDist=${electron}/libexec/electron \
        -c.electronVersion=${electron.version}

      runHook postBuild
    '';

    postBuild = ''
    '';

    installPhase = ''
      mkdir $out

      pushd dist/linux-unpacked
      mkdir -p $out/opt/google-chat-linux
      cp -r locales resources{,.pak} $out/opt/google-chat-linux
      popd

      makeWrapper '${electron}/bin/electron' "$out/bin/google-chat-linux" \
        --add-flags $out/opt/google-chat-linux/resources/app.asar \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --set-default ELECTRON_IS_DEV 0 \
        --inherit-argv0

      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications

      pushd dist/linux-unpacked/resources/icon
      for icon in *.png; do
        dir=$out/share/icons/hicolor/"''${icon%.png}"/apps
        mkdir -p "$dir"
        cp "$icon" "$dir"/${icon}.png
      done
      popd
    '';

    meta = with lib; {
      description = "Unofficial electron-based desktop client for Google Chat, electron included";
      homepage = "https://github.com/squalou/google-chat-linux";
      mainProgram = "google-chat-linux";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  }
