{
  description = "My flake based system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware = {
      url = "github:nixos/nixos-hardware/master";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      # url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-utils.follows = "flake-utils";
        # pre-commit-hooks.follows = "git-hooks";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    deploy-rs,
    sops-nix,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;

    myLib = import ./myLib/default.nix {inherit inputs;};
    hostSecretsDir = self + "./secrets";

    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    # forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
    #   pkgs = import nixpkgs { inherit system; };
    # });

    deployPkgs = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in
        import nixpkgs {
          inherit system;
          overlays = [
            deploy-rs.overlays.default
            (final: prev: {
              deploy-rs = {
                inherit (pkgs) deploy-rs;
                lib = prev.deploy-rs.lib;
              };
            })
          ];
        }
    );

    turingRk1Pkgs = import nixpkgs {
      system = "aarch64-linux";
      config.allowUnfreePredicate = pkg:
        builtins.elem (nixpkgs.lib.getName pkg) [
          # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
          "ubootTuringRK1"
        ];
    };

    kubeMasterIp = "192.168.2.12";
    k8s-hosts = [
      {
        name = "worker01";
        configName = "turing-rk1/k8s-worker";
        system = "aarch64-linux";
        hostname = "worker01";
        ip = "192.168.2.9";
        extraModules = [];
      }
      {
        name = "worker02";
        configName = "turing-rk1/k8s-worker";
        system = "aarch64-linux";
        hostname = "worker02";
        ip = "192.168.2.10";
        extraModules = [];
      }
      {
        name = "worker03";
        configName = "turing-rk1/k8s-worker";
        system = "aarch64-linux";
        hostname = "worker03";
        ip = "192.168.2.11";
        extraModules = [];
      }
      {
        name = "control01";
        configName = "turing-rk1/k8s-control";
        system = "aarch64-linux";
        hostname = "api";
        ip = kubeMasterIp;
        extraModules = [];
      }
    ];
  in rec {
    # packages = forAllSystems (pkgs: import ./pkgs {inherit pkgs;});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = builtins.listToAttrs (
      myLib.mkKubernetesCluster k8s-hosts "kube" kubeMasterIp
      # append regular systems
      ++ [
        {
          name = "desktop";
          value = myLib.mkSystem "desktop" {
            system = "x86_64-linux";
          };
        }
        {
          name = "work";
          value = myLib.mkSystem "work" {
            system = "x86_64-linux";
          };
        }
        {
          name = "home-server";
          value = myLib.mkSystem "home-server" {
            system = "x86_64-linux";
          };
        }
        {
          name = "turing-rk1-base";
          value = myLib.mkSystem "turing-rk1/base" {
            system = "aarch64-linux";
            # nixos/modules/installer/sd-card/sd-image-aarch64.nix
            extraModules = ["${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"];
          };
        }
      ]
    );

    deploy.nodes = builtins.listToAttrs (builtins.concatMap (host: [
        {
          name = host.name;
          value = {
            hostname = host.ip;
            sshUser = "luuk";
            user = "root";
            # autoRollback = false;
            # magicRollback = false;
            # profiles.system.path = deploy-rs.lib.${host.system}.activate.nixos self.nixosConfigurations.${host.name};
            profiles.system.path = deployPkgs.${host.system}.deploy-rs.lib.activate.nixos self.nixosConfigurations.${host.name};

            activationTimeout = 600;
            confirmTimeout = 60;

            remoteBuild = true;
          };
        }
      ])
      k8s-hosts
      ++ [
        {
          name = "home-server";
          value = {
            hostname = "192.168.2.13";
            sshUser = "luuk";
            user = "root";
            # autoRollback = false;
            # magicRollback = false;
            profiles = {
              system.path = deployPkgs.x86_64-linux.deploy-rs.lib.activate.nixos self.nixosConfigurations.home-server;
            };

            activationTimeout = 600;
            confirmTimeout = 60;
          };
        }
      ]);

    images.turing-rk1 = nixosConfigurations.turing-rk1-base.config.system.build.sdImage;
    # packages."x86_64-linux".google-chat-linux = (myLib.pkgsFor "x86_64-linux").callPackage ./pkgs/google-chat-linux.nix {};
    packages."aarch64-linux".uboot-turing-rk1 = import ./hosts/turing-rk1/base/uboot-sd-image.nix {
      stdenv = turingRk1Pkgs.stdenv;
      pkgs = turingRk1Pkgs;
    };

    homeManagerModules.default = ./modules/home-manager;
    nixosModules.default = ./modules/nixos;

    pre-commit = {
      settings = {
        hooks = {
          alejandra = {
            enable = true;
          };
        };
      };
    };

    devShells = forAllSystems (system: let
      pkgs = import nixpkgs {inherit system;};
      # writeJSONText = name: obj: pkgs.writeText "${name}.json" (builtins.toJSON obj);
      # caCsr = writeJSONText "kubernetes-ca" (nixpkgs.lib.attrsets.recursiveUpdate {
      #     key = {
      #       algo = "rsa";
      #       size = 2048;
      #     };
      #   } {
      #     CN = "kubernetes-ca";
      #     hosts = ["kubernetes-ca"] ++ [];
      #     # names = [
      #     #   {"O" = organization;}
      #     # ];
      #   });
      # make-certs = pkgs.writeShellScriptBin "make-certs" ''
      #   mkdir -p certs
      #   ${pkgs.cfssl}/bin/cfssl gencert -loglevel 2 -initca "${caCsr}" | ${pkgs.cfssl}/bin/cfssljson -bare ca
      #   mv ca-key.pem ca.csr ca.pem certs/
      # '';
    in
      with pkgs; {
        default = pkgs.mkShellNoCC {
          inputsFrom = [];
          # inputsFrom = [config.pre-commit.devShell];

          packages = with nixpkgs;
            [
              zstd
              netcat-openbsd
              yq-go
              kubeseal

              sops
              age
              ssh-to-age

              # make-certs
            ]
            ++ [
              inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.deploy-rs
            ];

          shellHook = ''
          '';
        };
      });
  };
}
