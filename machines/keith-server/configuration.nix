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
  services.tailscale.useRoutingFeatures = "both";
  services.auto-update.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  virtualisation.oci-containers.containers.valheim = {
    autoStart = false;
    image = "ghcr.io/lloesche/valheim-server";
    environmentFiles = [ /var/lib/valheim/environment ];
    extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
    ports = [ "2456-2457:2456-2457/udp" ];
    volumes = [ "/var/lib/valheim:/config" ];
  };

  services.caddy.enable = true;
  services.caddy.virtualHosts.":${toString constants.on-demand-tls.port}".extraConfig = ''
    route {
      @subdomains {
        ${pipe config.services.caddy.subdomains [
          attrNames
          (map (subdomain: optionalString (subdomain != "") "${subdomain}."))
          (map (prefix: "query domain=${prefix}${constants.kwbauson.fqdn}"))
          (concatStringsSep "\n")
        ]}
      }
      respond @subdomains 200
      respond 404
    }
  '';
  services.caddy.subdomainsOf = with constants; "${kwbauson.fqdn}:${toString http.port}";

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
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/nixos/caddy-environment";
  services.caddy.subdomains."" = with constants; ''
    basicauth /* {
      {$OLIVETIN_USERNAME} {$OLIVETIN_HASHED_PASSWORD}
    }
    reverse_proxy localhost:${toString olivetin.port}
  '';

  services.caddy.subdomains.api = constants.personal-api.port;

  systemd.tmpfiles.rules = [ "d /srv/files 777" ];
  services.caddy.subdomains.files = ''
    file_server browse {
      root /srv/files
    }
  '';

  services.scribblers.enable = true;
  services.caddy.subdomains.scribblers = constants.scribblers.port;

  services.netdata.enable = true;
  services.caddy.subdomains.netdata = constants.netdata.port;

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
  services.caddy.subdomains.jitsi = "";
  services.jitsi-videobridge.nat = with constants; {
    localAddress = keith-server.ip;
    publicAddress = kwbauson.ip;
  };
  services.jitsi-videobridge.config.videobridge.cc.trust-bwe = false;
  systemd.services.jitsi-meet-init-secrets.requiredBy = splitString " " config.systemd.services.jitsi-meet-init-secrets.unitConfig.Before;
  systemd.services.prosody.restartTriggers = [ jitsi-meet ];
  systemd.services.jicofo.restartTriggers = [ jitsi-meet ];
  systemd.services.jitsi-videobridge2.restartTriggers = [ jitsi-meet ];
  systemd.services.jitsi-meet-init-secrets.restartTriggers = [ jitsi-meet ];
}
