{ config, ... }:
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
        "${hostName}.${domain}" = {
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
      hostName = "jitsi.${hostName}.${domain}";
      config.enableNoisyMicDetection = false;
      config.p2p.enabled = false;

      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
        # MOBILE_APP_PROMO = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
    nginx.virtualHosts.${services.jitsi-meet.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
    prosody = {
      uploadHttp.domain = "upload.${services.jitsi-meet.hostName}";
      muc = [{ domain = "muc.${services.jitsi-meet.hostName}"; }];
    };
    # hercules-ci-agent.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };
}
