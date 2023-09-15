{ config, scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
    ./personal-api.nix
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.loadInInitrd = false;
  time.hardwareClockInLocalTime = true;

  services.openssh.enable = true;

  services.caddy = with constants; {
    enable = true;
    virtualHosts.":${toString on-demand-tls.port}".extraConfig = ''
      route {
        @filter {
          ${pipe config.services.caddy.subdomains [
            attrNames
            (map (subdomain: optionalString (subdomain != "") "${subdomain}."))
            (map (prefix: "not query domain=${prefix}${kwbauson.fqdn}"))
            (concatStringsSep "\n")
          ]}
        }
        respond @filter 404
        respond 200
      }
    '';
    subdomainsOf = "${kwbauson.fqdn}:${toString http.port}";
    subdomains = {
      "" = ''
        basicauth /* {
          {$OLIVETIN_USERNAME} {$OLIVETIN_HASHED_PASSWORD}
        }
        reverse_proxy localhost:${toString olivetin.port}
      '';
      test = ''respond "hello this is a test"'';
      jitsi = ""; # provided by jitsi service
      files = ''
        file_server browse {
          root /srv/files
        }
      '';
      netdata = netdata.port;
      api = personal-api.port;
      scribblers = scribblers.port;
    };
  };

  services.olivetin.enable = true;
  services.olivetin.config = ''
    listenAddressSingleHTTPFrontend: localhost:${toString constants.olivetin.port}
    actions:
      - title: Restart Jitsi
        icon: "&#128577;"
        shell: systemctl restart prosody jitsi-meet-init-secrets jicofo jitsi-videobridge2
        timeout: 10

      - title: Reboot Server
        icon: "&#128683;"
        shell: reboot
  '';

  services.scribblers.enable = true;

  services.netdata.enable = true;

  systemd.tmpfiles.rules = [ "d /srv/files 777" ];

  services.github-runner = {
    enable = true;
    nodeRuntimes = [ "node16" "node20" ];
    extraLabels = [ "nix" ];
    extraPackages = [ gh cachix ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  services.jitsi-meet = {
    enable = true;
    nginx.enable = false;
    caddy.enable = true;
    hostName = "jitsi.${constants.kwbauson.fqdn}:80";
    config = {
      analytics.disabled = true;
      desktopSharingFrameRate = { min = 5; max = 30; };
      disableTileEnlargement = true;
      enableNoAudioDetection = false;
      enableNoisyMicDetection = false;
      noiseSuppression.krisp.enable = false;
      maxFullResolutionParticipants = -1;
      p2p.enabled = false;
    };
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
    };
  };
  services.jitsi-videobridge.nat = with constants; {
    localAddress = keith-server.ip;
    publicAddress = kwbauson.ip;
  };
  services.jitsi-videobridge.config.videobridge.cc.trust-bwe = false;

  systemd.services = recursiveUpdate
    {
      caddy.serviceConfig.EnvironmentFile = "/etc/nixos/caddy-environment";
      jitsi-meet-init-secrets.requiredBy = splitString " " config.systemd.services.jitsi-meet-init-secrets.unitConfig.Before;
    }
    (genAttrs [ "prosody" "jicofo" "jitsi-meet-init-secrets" "jitsi-videobridge2" ] (_: {
      restartTriggers = [ config.systemd.units."caddy.service".unit ];
    }));

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.containers.valheim = {
    autoStart = false;
    image = "ghcr.io/lloesche/valheim-server";
    environmentFiles = [ /var/lib/valheim/environment ];
    extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
    ports = [ "2456-2457:2456-2457/udp" ];
    volumes = [ "/var/lib/valheim:/config" ];
  };

  services.auto-update.enable = true;

  services.tailscale.useRoutingFeatures = "both";
}
