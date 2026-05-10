{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myNixOS.k8s;
  etcdEndpoints = ["https://${cfg.kubeMasterHostname}:2379"];
  apiAddr = "https://${cfg.kubeMasterHostname}:${toString cfg.kubeMasterApiServerPort}";
in {
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
        coredns = {
          finalImageTag = "1.10.1";
          imageDigest = "sha256:a0ead06651cf580044aeb0a0feba63591858fb2e43ade8c9dea45a6a89ae7e5e";
          imageName = "coredns/coredns";
          sha256 = "0c4vdbklgjrzi6qc5020dvi8x3mayq4li09rrq2w0hcjdljj0yf9";
        };
      };
    };
    proxy = {
      enable = true;
    };
    flannel = {
      enable = true;
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

  # systemd.services.etcd = {
  #   environment = {
  #     ETCD_UNSUPPORTED_ARCH = "arm64";
  #   };
  # };
  services.etcd = lib.mkIf (cfg.role == "control") {
    enable = true;
  };
  services.flannel = {
    etcd = {
      endpoints = etcdEndpoints;
    };
  };
}
