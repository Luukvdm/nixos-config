# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? (import ../nixpkgs.nix) {}}: {
  # example = pkgs.callPackage ./example { };
  google-chat-linux = pkgs.callPackage ./google-chat-linux.nix {};
  # bolt = pkgs.callPackage ./bolt.nix {};
  uboot-turing-rk1 = pkgs.callPackage ./uboot-turing-rk1.nix {
    stdenv = pkgs.stdenv;
    inherit pkgs;
  };
}
