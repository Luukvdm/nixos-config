{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../default.nix
  ];

  myNixOS = {
    k8s = {
      enable = true;
      role = "worker";
      # caFile = config.sops.secrets.k8sCaPem.path;
      caFile = pkgs.writeTextFile {
        name = "ca.pem";
        text = ''
          -----BEGIN CERTIFICATE-----
          MIIDbjCCAlagAwIBAgIUMjtJZDvPyIQsPZVK2/V422kTBIYwDQYJKoZIhvcNAQEL
          BQAwTzELMAkGA1UEBhMCTkwxFjAUBgNVBAgTDU5vb3JkLUJyYWJhbnQxEzARBgNV
          BAcTCkV0dGVuLUxldXIxEzARBgNVBAMTCmt1YmVybmV0ZXMwHhcNMjUxMjE4MjEx
          MTAwWhcNMzAxMjE3MjExMTAwWjBPMQswCQYDVQQGEwJOTDEWMBQGA1UECBMNTm9v
          cmQtQnJhYmFudDETMBEGA1UEBxMKRXR0ZW4tTGV1cjETMBEGA1UEAxMKa3ViZXJu
          ZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANusZZVBCX7RSYCC
          pp36hESDsDmCpgBx1yQmoMr5he4RzFiSf9QjFyMc2DGjel5hfL7kApB3tc0utsm3
          mZ7EygCL2kZmB0pQ7UxaB2EBwDCQCDLcVR2zOTBQfGXz5spWFWSkRg61LBYQAQ6x
          R08Vv4IRjcJ4citaeLIHxAS/z2dsM0CSNK9rj6tK2bN2lnVDYbXMlDfVP/ohrrgA
          /mLwYM1IjLoYP7v+ZupE8D9jJQbQ9G7hC2CdRO7quSyMgOOncrFwn1gfva7yEjQF
          3b5eGcY5lrjojcUt0rcW6hmWrVdFP9gc0s7kxFS4ekKG88fooO9MrbyRS4T207v+
          bNuTPesCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
          HQYDVR0OBBYEFPTAq+1GgxQQLOLUUJ2Vs4b4SvuJMA0GCSqGSIb3DQEBCwUAA4IB
          AQA+VKp8i9BISUv8O27Elnf8Zmu4RX4wnFQrM2u1BiuuHY//YDeBKmuebzsQHc13
          A7RAY5V06HS2lMei44+3umMXWlrwkkOLU5rJ/SfVEQM1CZVYBlWFQyF9HstNf1QU
          aRbwSLH56L3FTY7smrYejdh77UZVdbzndQGWk36qlJOm8VtUvpWVKaFzGyMcCcnN
          eFFnWVokBBfyEZGQ/RsgyUgBaVNYbXa2gr04X0TIzChe1uQWPVuiGrjS8sdwB7rZ
          +uB0+r/UGM92N9hJAx761n5utfYFj8cO2p6pj+soR08KakqobTBJ7wGHJjw9atvl
          Tno5p53A3/JLoiudNi4KQ/FW
          -----END CERTIFICATE-----
        '';
      };
    };
    # sops = {
    #   secrets = {
    #     k8sCaPem = {
    #       sopsFile = ../../../secrets/k8s/ca.pem;
    #       format = "binary";
    #     };
    #   };
    # };
  };

  environment.systemPackages = with pkgs; [
  ];
}
