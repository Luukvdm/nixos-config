{inputs, ...}: let
  myLib = (import ./default.nix) {inherit inputs;};
  outputs = inputs.self.outputs;
in rec {
  mkSystem = host: {
    system ? "x86_64-linux",
    buildSystem ? "x86_64-linux",
    defaultUsername ? "luuk",
    description ? "",
    extraModules ? [],
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs outputs myLib;

        username = defaultUsername;
        hostSecretsDir = inputs.self + "/secrets";

        pkgsUnstable = inputs.nixpkgs-unstable.legacyPackages.${system};
      };

      modules =
        [
          ({config, ...}: {
            nixpkgs = {
              hostPlatform = system;
              buildPlatform = buildSystem;
            };
          })

          ../modules/defaults/user.nix
          ../modules/defaults/nix-settings.nix
          ../modules/defaults/system.nix
          outputs.nixosModules.default
          ../hosts/${host}
        ]
        ++ extraModules;
    };

  mkKubernetesCluster = hosts: domain: kubeMasterIp:
    builtins.concatMap (host: [
      {
        name = host.name;
        value = myLib.mkSystem "${host.configName}" {
          system = host.system;

          # extraHosts = nixpkgs.lib.concatMapStringsSep "\n" (h: "${h.ip} ${h.hostName}.${domain}") (nixpkgs.lib.lists.remove host k8s-hosts);
          extraModules =
            [
              ({
                config,
                lib,
                ...
              }: {
                myNixOS = {
                  # k8s = {
                  #   kubeMasterIp = "192.168.2.20";
                  # };
                  #
                  networkd = {
                    enable = true;
                    hostname = host.hostName;
                    domain = "kube";
                    extraHosts = lib.concatMap (h: "${h.ip} ${h.hostName}.${domain}") (lib.lists.remove host hosts);
                    staticIp = host.ip;
                    staticGateway = "192.168.2.254";
                  };
                };
              })
            ]
            ++ host.extraModules;
        };
      }
    ])
    hosts;

  # unfreePkgs = import inputs.nixpkgs {
  #   # system = inherit inputs.nixpkgs.system;
  #   config.allowUnfree = inputs.nixpkgs.lib.mkDefault true;
  # };
  # pkgsFor = system: unfreePkgs.legacyPackages.${system};

  filesIn = dir: (map (fname: dir + "/${fname}")
    (builtins.attrNames (builtins.readDir dir)));

  fileNameOf = path: (builtins.head (builtins.split "\\." (baseNameOf path)));

  # Evaluates nixos/home-manager module and extends it's options / config
  extendModule = {path, ...} @ args: {pkgs, ...} @ margs: let
    eval =
      if (builtins.isString path) || (builtins.isPath path)
      then import path margs
      else path margs;
    evalNoImports = builtins.removeAttrs eval ["imports" "options"];

    extra =
      if (builtins.hasAttr "extraOptions" args) || (builtins.hasAttr "extraConfig" args)
      then [
        ({...}: {
          options = args.extraOptions or {};
          config = args.extraConfig or {};
        })
      ]
      else [];
  in {
    imports =
      (eval.imports or [])
      ++ extra;

    options =
      if builtins.hasAttr "optionsExtension" args
      then (args.optionsExtension (eval.options or {}))
      else (eval.options or {});

    config =
      if builtins.hasAttr "configExtension" args
      then (args.configExtension (eval.config or evalNoImports))
      else (eval.config or evalNoImports);
  };

  # Applies extendModules to all modules
  # modules can be defined in the same way
  # as regular imports, or taken from "filesIn"
  extendModules = extension: modules:
    map (
      f: let
        name = fileNameOf f;
      in (extendModule ((extension name) // {path = f;}))
    )
    modules;
}
