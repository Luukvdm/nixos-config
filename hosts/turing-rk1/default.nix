{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  imports = [
    outputs.nixosModules.default
    ./base/base.nix
  ];

  myNixOS = {
    sops = {
      enable = true;
      sshKeyDir = "sops";
    };
    networking = {
      enable = true;
      hostname = lib.mkDefault "turing-rk1";
      domain = lib.mkDefault "kube";
      # staticIp = lib.mkDefault "192.168.2.9";
      enableFirewall = false;
      enableNftables = true;
    };
    networkd = {
      enable = lib.mkDefault true;
      hostname = lib.mkDefault "turing-rk1";
      domain = lib.mkDefault "kube";
      staticIp = lib.mkDefault "192.168.2.9";
    };
    neovim = {
      enable = false;
      enableLsp = false;
      enableNoneLs = false;
      enableTreesitter = false;
      go.enable = false;
    };
    # k8s-tools = {
    #   enable = false;
    #   installPackages = false;
    # };

    user = {
      extraGroups = ["networkmanager" "docker"];
      shell = pkgs.bash;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          # nixpkgs.ubootTuringRK1 includes proprietary binaries from Rockchip
          "ubootTuringRK1"
        ];
    };
  };

  environment.systemPackages = with pkgs; [
    cross.neovim
  ];
  security.sudo.wheelNeedsPassword = false;
}
