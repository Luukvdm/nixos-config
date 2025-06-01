{
  description = "My flake based system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware = {
      url = "github:nixos/nixos-hardware/master";
    };

    # agenix = {
    #   url = "github:ryantm/agenix/564595d0ad4be7277e07fa63b5a991b3c645655d";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    sops-nix,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;

    myLib = import ./myLib/default.nix {inherit inputs;};
    # hostSecretsDir = self + "/secrets";

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    # forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
    #   pkgs = import nixpkgs { inherit system; };
    # });
  in {
    packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      desktop = myLib.mkSystem "desktop" {
        system = "x86_64-linux";
      };
      work = myLib.mkSystem "work" {
        system = "x86_64-linux";
      };
    };

    homeManagerModules.default = ./modules/home-manager;
    nixosModules.default = ./modules/nixos;
  };
}
