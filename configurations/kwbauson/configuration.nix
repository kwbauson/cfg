{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  services.nix-serve = {
    # enable = true;
    secretKeyFile = "/etc/nixos/cache-key-private.pem";
  };

  nixpkgs.overlays = [
    (self: super: {
      jitsi-meet = super.jitsi-meet.overrideAttrs (_: { src = ../../var/jitsi-meet.tar.bz2; });
    })
  ];

  networking = {
    hostName = "kwbauson";
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 5000 ];
    interfaces.ens3.useDHCP = true;
  };

  services = {
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
        "${config.networking.hostName}.${config.networking.domain}" = {
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
      hostName = "jitsi.${config.networking.hostName}.${config.networking.domain}";
      config.enableNoisyMicDetection = false;
      config.p2p.enabled = false;

      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
    nginx.virtualHosts.${config.services.jitsi-meet.hostName} = {
      forceSSL = true;
      enableACME = true;
    };
    prosody = {
      uploadHttp.domain = "upload.${config.services.jitsi-meet.hostName}";
      muc = [{ domain = "muc.${config.services.jitsi-meet.hostName}"; }];
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };
}
