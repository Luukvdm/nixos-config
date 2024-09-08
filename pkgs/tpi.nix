{
  pkgs,
  system,
}: let
  version = "1.0.5";
in
  pkgs.rustPlatform.buildRustPackage rec {
    pname = "tpi";
    version = "1.0.5";
    src = pkgs.fetchFromGitHub {
      owner = "turing-machines";
      repo = "tpi";
      rev = "f9a5d58f42428f861693bdeac5acc0171872d807";
      sha256 = "sha256-51Jz+7cylXypNHvi2q04MUY14OfrkrZQbpb0LNNKpv4=";
    };
    cargoHash = "sha256-8HXmrS2ukB4zpeIg+Ldy+7Jf15PcF5XRdoeWc7dDbAE=";
    # cargoLock.lockFile = ./Cargo.lock;
  }
