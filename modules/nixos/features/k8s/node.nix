{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s;
  etcdEndpoints = ["https://${cfg.kubeMasterHostname}:2379"];
  apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
in {
  config = lib.mkIf cfg.enableNode {
    security.pki.certificateFiles = [cfg.caPem];

    # https://github.com/NixOS/nixpkgs/issues/434442
    services.certmgr.specs = lib.mkForce (
      let
        mkSpec = _: cert: {
          inherit (cert) action;
          authority = {
            remote = "https://${config.services.kubernetes.masterAddress}:${toString config.services.cfssl.port}";
            root_ca = cert.caCert;
            profile = "default";
            auth_key_file = "${config.services.kubernetes.secretsPath}/apitoken.secret";
          };
          certificate = {
            path = cert.cert;
          };
          private_key = cert.privateKeyOptions;
          request = {
            # NOTE: This is the only change from upstream
            hosts = [(lib.replaceString ":" "-" cert.CN)] ++ cert.hosts ++ lib.optional (cert.name == "kubelet") cfg.hostIp;
            inherit (cert) CN;
            key = {
              algo = "rsa";
              size = 2048;
            };
            names = [cert.fields];
          };
        };
      in
        lib.mapAttrs mkSpec config.services.kubernetes.pki.certs
    );

    services.kubernetes = {
      masterAddress = cfg.kubeMasterHostname;
      apiserverAddress = apiAddr;

      easyCerts = false;
      # on the worker node kube-certmgr-bootstrap.service populates the file
      caFile =
        if cfg.role == "control"
        then cfg.caPem
        else "${config.services.kubernetes.secretsPath}/ca.pem";
      pki = {
        enable = true;
        genCfsslCACert = false;
        genCfsslAPICerts = cfg.role == "control";
        genCfsslAPIToken = false;
        # fetches the CA from cfssl and outputs it in kubernetes.caFile
        pkiTrustOnBootstrap = false; # cfg.role == "worker";
        caCertPathPrefix =
          if cfg.role == "control"
          then "${config.services.cfssl.dataDir}/ca"
          else "";
      };

      kubelet = {
        enable = true;
        unschedulable = false;
        clientCaFile = cfg.caPem;
        # unschedulable = cfg.role == "control";
        # taints = {
        #   master = lib.mkIf (cfg.role == "control") {
        #     key = "node-role.kubernetes.io/master";
        #     value = "true";
        #     effect = "NoSchedule";
        #   };
        # };
        kubeconfig = {
          server = apiAddr;
        };
      };

      apiserver = lib.mkIf (cfg.role == "control") {
        enable = true;

        securePort = cfg.kubeMasterApiServerPort;
        # uses the bind-address by default
        advertiseAddress = cfg.kubeMasterIp;

        allowPrivileged = true;

        # configure Kubernetes aggregation layer
        extraOpts = ''
          --requestheader-client-ca-file=${config.services.kubernetes.secretsPath}/ca.pem \
          --requestheader-allowed-names=front-proxy-client,kube-apiserver-proxy-client \
          --requestheader-extra-headers-prefix=X-Remote-Extra- \
          --requestheader-group-headers=X-Remote-Group \
          --requestheader-username-headers=X-Remote-User \
          --proxy-client-cert-file=${config.services.kubernetes.secretsPath}/kube-apiserver-proxy-client.pem \
          --proxy-client-key-file=${config.services.kubernetes.secretsPath}/kube-apiserver-proxy-client-key.pem
        '';
      };

      scheduler = lib.mkIf (cfg.role == "control") {
        enable = true;
      };
      controllerManager = lib.mkIf (cfg.role == "control") {
        enable = true;
      };
      addonManager = lib.mkIf (cfg.role == "control") {
        enable = true;
      };
      addons = {
        dns = {
          enable = true;
          corefile = lib.mkIf (config.myNixOS.networkd.enable) ''
            .:10053 {
              errors
              health :10054
              kubernetes ${config.services.kubernetes.addons.dns.clusterDomain} in-addr.arpa ip6.arpa {
                pods insecure
                fallthrough in-addr.arpa ip6.arpa
              }
              prometheus :10055
              forward . ${builtins.concatStringsSep " " config.myNixOS.networkd.dns}
              cache 30
              loop
              reload
              loadbalance
            }
          '';
        };
      };
      proxy = {
        enable = false;
      };
      flannel = {
        enable = cfg.enableFlannel;
      };

      clusterCidr = "10.200.0.0/16"; # the default value
    };

    sops.secrets =
      if cfg.role == "control"
      then {
        "cfssl-ca-pem" = {
          sopsFile = ../../../../secrets/k8s/ca.pem;
          format = "binary";
          path = "${config.services.cfssl.dataDir}/ca.pem";

          owner = "cfssl";
          group = "cfssl";
          mode = "0444";
        };
        "cfssl-ca-key-pem" = {
          sopsFile = ../../../../secrets/k8s/ca-key.pem;
          format = "binary";
          path = "${config.services.cfssl.dataDir}/ca-key.pem";

          owner = "cfssl";
          group = "cfssl";
          mode = "0440";
        };
        "cfssl-ca-csr" = {
          sopsFile = ../../../../secrets/k8s/ca.csr;
          format = "binary";
          path = "${config.services.cfssl.dataDir}/ca.csr";

          owner = "cfssl";
          group = "cfssl";
          mode = "0440";
        };
        "cfssl-apitoken-secret" = {
          sopsFile = ../../../../secrets/k8s/apitoken.secret;
          format = "binary";
          path = "${config.services.cfssl.dataDir}/apitoken.secret";

          owner = "cfssl";
          group = "cfssl";
          mode = "0440";
        };
        "kubernetes-ca-pem" = {
          sopsFile = ../../../../secrets/k8s/ca.pem;
          format = "binary";
          path = "${config.services.kubernetes.secretsPath}/ca.pem";

          owner = "kubernetes";
          group = "kubernetes";
          mode = "0444";
        };
        "kubernetes-ca-key-pem" = {
          sopsFile = ../../../../secrets/k8s/ca-key.pem;
          format = "binary";
          path = "${config.services.kubernetes.secretsPath}/ca-key.pem";

          owner = "kubernetes";
          group = "kubernetes";
          mode = "0440";
        };
        "kubernetes-ca-csr" = {
          sopsFile = ../../../../secrets/k8s/ca.csr;
          format = "binary";
          path = "${config.services.kubernetes.secretsPath}/ca.csr";

          owner = "kubernetes";
          group = "kubernetes";
          mode = "0440";
        };
      }
      else {
        "kubernetes-apitoken-secret" = {
          sopsFile = ../../../../secrets/k8s/apitoken.secret;
          format = "binary";
          path = "${config.services.kubernetes.secretsPath}/apitoken.secret";

          owner = "kubernetes";
          group = "kubernetes";
          mode = "0440";
        };
      };

    system.activationScripts.setupCustomCni = lib.mkIf (cfg.cniBinPath != "/opt/cni/bin/") ''
      mkdir -p ${cfg.cniBinPath}
      ln -fs ${pkgs.cni-plugins}/bin/* ${cfg.cniBinPath}
    '';
    virtualisation.containerd.settings = {
      version = 2;
      plugins."io.containerd.grpc.v1.cri".cni = {
        bin_dir = cfg.cniBinPath;
        conf_dir = "/etc/cni/net.d";
      };
    };

    services.etcd = lib.mkIf (cfg.role == "control") {
      enable = true;
    };
    services.flannel = {
      etcd = {
        endpoints = etcdEndpoints;
      };
    };
  };
}
