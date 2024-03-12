{
  config,
  pkgs,
  ...
}: let
  google-chat-linux = pkgs.callPackage ./build.nix {};
in {
  environment.systemPackages = [
    google-chat-linux
  ];
}
