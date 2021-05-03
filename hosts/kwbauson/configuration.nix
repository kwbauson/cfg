{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
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
      virtualHosts = {
        ${fqdn} = {
          enableACME = true;
          forceSSL = true;
          locations."/" = {
            root = "/srv/files";
            extraConfig = "autoindex on;";
          };
        };
        "cache.${fqdn}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = with services.nix-serve; "http://${bindAddress}:${toString port}";
        };
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
      extraPackages = with pkgs; [ cachix gh ];
    };
    nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nixos/cache-priv-key.pem";
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };
}
