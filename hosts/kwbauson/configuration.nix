{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./gitlab-runner-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  nix.extraOptions = ''
    min-free = ${toString (80 * 1024 * 1024 * 1024)}
    max-free = ${toString (10 * 1024 * 1024 * 1024)}
  '';

  boot.tmpOnTmpfs = lib.mkForce false;

  networking = {
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services = with config; with networking; {
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
        "cache.${fqdn}".locations."/".proxyPass = with services.nix-serve; "http://${bindAddress}:${toString port}";
        "netdata.${fqdn}".locations."/".proxyPass = "http://localhost:19999";
      };
    };
    jitsi-meet = {
      enable = true;
      hostName = "jitsi.${fqdn}";
      config.enableNoisyMicDetection = false;

      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
        # MOBILE_APP_PROMO = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
    github-runner = {
      enable = true;
      tokenFile = "/etc/nixos/self-hosted-runner-token";
      url = "https://github.com/kwbauson/cfg";
      extraPackages = with pkgs; [ gh ];
    };
    nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nixos/cache-priv-key.pem";
    };
    netdata.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };
}
