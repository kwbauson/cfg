{ config, scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
    modules.olivetin
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.loadInInitrd = false;
  time.hardwareClockInLocalTime = true;

  services.openssh.enable = true;

  services.caddy.enable = true;
  services.caddy.virtualHosts = with constants; {
    ":${toString olivetin.authed-port}".extraConfig = ''
      basicauth /* {
        {$OLIVETIN_USERNAME} {$OLIVETIN_HASHED_PASSWORD}
      }
      reverse_proxy localhost:${toString olivetin.port}
    '';
    ":${toString file-server.port}".extraConfig = ''
      file_server browse {
        root /srv/files
      }
    '';
    ":${toString jitsi.caddy-port}".extraConfig = with config.services; caddy.virtualHosts.${jitsi-meet.hostName}.extraConfig;
  };

  services.netdata.enable = true;

  systemd.tmpfiles.rules = [ "d /srv/files 777" ];

  services.github-runner = {
    enable = true;
    extraLabels = [ "nix" ];
    extraPackages = [ cachix ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  services.jitsi-meet = {
    enable = true;
    nginx.enable = false;
    caddy.enable = true;
    hostName = "jitsi.${constants.kwbauson.fqdn}";
    config = {
      analytics.disabled = true;
      desktopSharingFrameRate = { min = 5; max = 30; };
      disableSimulcast = true;
      disableTileEnlargement = true;
      enableNoAudioDetection = false;
      enableNoisyMicDetection = false;
      enableUnifiedOnChrome = false;
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

  systemd.services = {
    caddy.serviceConfig.EnvironmentFile = "/etc/nixos/caddy-environment";
  } // genAttrs [ "prosody" "jicofo" "jitsi-meet-init-secrets" "jitsi-videobridge2" ] (_: {
    restartTriggers = [ config.systemd.units."caddy.service".unit ];
  });

  virtualisation.docker.enable = true;
  virtualisation.oci-containers.containers.valheim = {
    autoStart = true;
    image = "ghcr.io/lloesche/valheim-server";
    environmentFiles = [ /var/lib/valheim/environment ];
    extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
    ports = [ "2456-2457:2456-2457/udp" ];
    volumes = [ "/var/lib/valheim:/config" ];
  };
}
