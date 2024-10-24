{ config, scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
    ./personal-api.nix
    "${cobi.src}/hosts/modules/games/palworld.nix"
    "${cobi.src}/hosts/modules/games/valheim.nix"
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.initrd.enable = false;
  hardware.amdgpu.legacySupport.enable = true;
  hardware.amdgpu.opencl.enable = true;
  time.hardwareClockInLocalTime = true;
  services.tailscale.useRoutingFeatures = "both";
  services.auto-update.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";

  networking = {
    firewall.allowedTCPPorts = with constants; [ temp-http.port config.services.palworld.port ] ++ valheim.ports;
    firewall.allowedUDPPorts = config.networking.firewall.allowedTCPPorts;
  };

  services.valheim = {
    enable = true;
    serverName = "hangin bois";
    worldName = "hangin";
  };

  services.palworld = {
    enable = true;
    worldSettings.ServerName = "Kenneth Palworld Server";
    worldSettings.ServerPassword = "$PALWORLD_SERVER_PASSWORD";
    worldSettings.BaseCampWorkerMaxNum = "30";
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

  services.github-runners.keith-server = {
    enable = true;
    extraLabels = [ "nix" ];
    extraPackages = [ gh cachix ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  services.ddclient = {
    enable = true;
    configFile = toFile "ddclient.conf" ''
      use=web, web=checkip.dyndns.com/, web-skip='Current IP Address: '
      protocol=porkbun
      apikey_env=APIKEY
      secretapikey_env=SECRETAPIKEY
      home.kwbauson.com,palworld.kwbauson.com
    '';
  };
  systemd.services.ddclient.serviceConfig.EnvironmentFile = "/etc/nixos/ddclient-env";
}
