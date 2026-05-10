{
  config,
  lib,
  pkgs,
  options,
  username,
  ...
}: let
  cfg = config.myNixOS.guitar;
in {
  # https://wiki.nixos.org/wiki/Electric_guitar_interface_setup

  myNixOS.user.extraGroups = ["audio" "rtkit"];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Required for yabridge/wine VST bridging
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
    };

    # Global low-latency defaults for native JACK clients
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000; # Fixed rate avoids resampling latency
        "default.clock.quantum" = 128; # ~5ms latency at 48kHz
        "default.clock.min-quantum" = 64; # ~2.5ms latency at 48kHz
        "default.clock.max-quantum" = 512;
      };
    };

    # Crucial: Match low-latency for PulseAudio clients (browsers, Steam/Rocksmith)
    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "64/48000"; # Start with 64, not 32, for stability
        "pulse.default.req" = "64/48000";
        "pulse.max.req" = "128/48000";
      };
    };
  };

  # RTKit handles real-time privileges via D-Bus/Polkit.
  security.rtkit.enable = true;

  # Critical: Allow unlimited memlock for real-time audio buffers
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "95";
    }
  ];

  environment = {
    systemPackages = with pkgs; [
      qpwgraph
      pavucontrol
      alsa-scarlett-gui
      scarlett2

      ardour

      guitarix

      tuxguitar

      wineasio
    ];
  };

  systemd.user.services.auto-link-guitar = {
    description = "Auto-link Scarlett to Guitarix via Pipewire";
    wantedBy = ["default.target"];
    after = ["pipewire.service"];
    path = [pkgs.pipewire pkgs.gnugrep];

    script = ''
      # 1. Wait until Guitarix is running and registers its input node
      while ! pw-link -i | grep -q "gx_head_amp:in_0"; do
        sleep 2
      done

      # 2. Link the Scarlett output port to the Guitarix input port
      pw-link "Split Scarlett Solo 4th Gen Input 1 Inst/Line [Split Scarlett Solo 4th Gen Input 1 Inst/Line input]:monitor_AUX0" "gx_head_amp:in_0"
    '';

    serviceConfig = {
      # If Guitarix isn't open yet, it keeps checking.
      # Note: If you close and reopen Guitarix, you'd need to restart this service:
      # systemctl --user restart auto-link-guitar
      Type = "simple";
    };
  };

  programs.steam = {
    package = pkgs.steam.override {
      extraLibraries = pkgs': with pkgs'; [pkgsi686Linux.pipewire.jack]; # Adds pipewire jack (32-bit)
      extraPkgs = pkgs': with pkgs'; [wineasio]; # Adds wineasio
    };
  };
}
