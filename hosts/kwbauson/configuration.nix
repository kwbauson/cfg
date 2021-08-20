{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    networkmanager.enable = lib.mkForce false;
    interfaces.enp3s0.ipv4.addresses = [{ address = "208.87.134.252"; prefixLength = 24; }];
    defaultGateway.address = "208.87.134.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services = with config; with networking; {
    hercules-ci-agent.enable = true;
    hercules-ci-agent.checkNix = false;
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = builtins.mapAttrs (_: x: x // { enableACME = true; forceSSL = true; }) {
        ${fqdn} = {
          locations."/" = {
            root = "/srv/files";
            extraConfig = "autoindex on;";
          };
        };
        "netdata.${fqdn}".locations."/".proxyPass = "http://localhost:19999";
      };
    };
    jitsi-meet = {
      enable = true;
      hostName = "jitsi.${fqdn}";
      config.enableNoisyMicDetection = false;
      config.p2p.enabled = true;
      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
        # MOBILE_APP_PROMO = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
    github-runner = {
      enable = true;
      extraLabels = [ "nix" ];
      tokenFile = "/etc/nixos/self-hosted-runner-token";
      url = "https://github.com/kwbauson/cfg";
      extraPackages = with pkgs; [ gh ];
    };
    netdata.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };

  virtualisation.docker.enable = true;
}
