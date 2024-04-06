{
  description = "My flake based system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
      url = "github:nix-community/nixvim"; # /nixos-23.11
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    # Your custom packages
    # Acessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});

    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    # nixosModules = import ./modules/nixos;

    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    # homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        # specialArgs = {
        #   inherit inputs outputs myLib;
        # };

        specialArgs = {
          inherit inputs outputs myLib;
          hostSecretsDir = self + "/secrets";
        };
        modules = [
          ./hosts/thinkpad/configuration.nix

          # inputs.home-manager.nixosModules.home-manager
          outputs.nixosModules.default
        ];
      };
      work = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs myLib;
          hostSecretsDir = self + "/secrets";
        };
        modules = [
          ./hosts/work/configuration.nix
          # sops-nix.nixosModules.sops
          outputs.nixosModules.default
        ];
      };
      pi = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs myLib;
        };
        modules = [
          ./hosts/pi/configuration.nix

          # inputs.home-manager.nixosModules.home-manager
          outputs.nixosModules.default
          # ./modules/home-manager
        ];
      };
    };
    homeConfigurations = {
      "pengu@pi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {
          inherit inputs outputs myLib;
        };
        modules = [
          ./hosts/pi/home.nix
          outputs.homeManagerModules.default
        ];
      };
    };

    homeManagerModules.default = ./modules/home-manager;
    nixosModules.default = ./modules/nixos;
  };
}
