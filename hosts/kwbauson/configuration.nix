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

  nix.gc = {
    automatic = true;
    options = "--min-freed \$((20 * 1024**3)) --max-freed \$((20 * 1024**3))";
  };

  networking = {
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 5000 9090 3000 8000 ];
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
      extraPackages = with pkgs; [ coreutils cachix git gh ];
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };
}
