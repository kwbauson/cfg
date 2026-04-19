{ config, scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
    modules.ci-substituters
    ./personal-api.nix
    "${cobi.src}/hosts/modules/games/palworld.nix"
    "${cobi.src}/hosts/modules/games/valheim.nix"
    searchix.flake.nixosModules.web
  ];

  machine.tailscale-ip = "100.107.6.112";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.initrd.enable = false;
  hardware.amdgpu.legacySupport.enable = true;
  hardware.amdgpu.opencl.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  services.auto-update.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  systemd.defaultUnit = mkForce "multi-user.target";
  boot.kernel.sysctl."kernel.panic" = 60;

  zramSwap.memoryPercent = 25;
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 64 * 1024;
  }];

  networking = {
    firewall.allowedTCPPorts = with constants; [ temp-http.port config.services.palworld.port ] ++ valheim.ports;
    firewall.allowedUDPPorts = config.networking.firewall.allowedTCPPorts;
  };
  services._3proxy.enable = true;

  services.valheim = {
    enable = true;
    serverName = "hangin bois";
    worldName = "hangin";
  };
  systemd.services.valheim.wantedBy = mkForce [ ];

  services.palworld = {
    enable = true;
    worldSettings.ServerName = "Kenneth Palworld Server";
    worldSettings.ServerPassword = "$PALWORLD_SERVER_PASSWORD";
    worldSettings.BaseCampWorkerMaxNum = "30";
  };
  systemd.services.palworld.wantedBy = mkForce [ ];

  services.caddy.enable = true;
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/nixos/caddy-environment";
  services.caddy.subdomainsOf = constants.kwbauson.fqdn;
  services.caddy.subdomains."" = "redir /* https://auth.${config.services.caddy.subdomainsOf}";
  services.caddy.subdomains.auth = "authenticate with default";
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

  services.caddy.subdomains.api = constants.personal-api.port;

  services.caddy.subdomains.playground = ''
    authorize with admin
    reverse_proxy http://keith-desktop:3000
  '';

  systemd.tmpfiles.rules = [ "d /srv/files 777" ];
  services.caddy.subdomains.files = ''
    file_server browse {
      root /srv/files
    }
  '';

  services.scribblers.enable = true;
  services.caddy.subdomains.scribblers = constants.scribblers.port;

  services.github-runners.keith-server = {
    enable = true;
    nodeRuntimes = [ "node20" "node24" ];
    extraLabels = [ "nix" system ];
    extraPackages = [ gh cachix ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  services.searchix.enable = true;
  services.searchix.settings = {
    web.baseUrl = "https://searchix.kwbauson.com";
    importer.Sources = {
      darwin.Enable = true;
      home-manager.Enable = true;
      nur.Enable = true;
    };
  };
  systemd.services.searchix.environment.NIX_PATH = "nixpkgs=${nixpkgsPath}";
  services.caddy.subdomains.searchix = config.services.searchix.settings.web.port;

  services.grafana = {
    enable = true;
    settings = {
      server.http_addr = machine.tailscale-ip;
      server.http_port = 8888;
      server.domain = machine.name;
      security.admin_user = "keith";
      security.secret_key = "$__file{/etc/nixos/grafana-secret-key}";
    };
  };
  systemd.services.grafana.after = [ "tailscaled.service" ];
  services.prometheus = {
    enable = true;
    port = constants.prometheus.port;
    listenAddress = constants.localhost.ip;
    scrapeConfigs = [{
      job_name = "node";
      static_configs = forEach (attrValues machines) (machine: {
        labels.instance = machine.name;
        targets = [ "${machine.tailscale-ip}:${toString constants.prometheus.exporters.node.port}" ];
      });
    }];
  };
  services.loki = {
    enable = true;
    # adapted from https://grafana.com/docs/loki/latest/configure/examples/configuration-examples/#1-local-configuration-exampleyaml
    configuration = {
      auth_enabled = false;
      server.http_listen_port = constants.loki.port;
      common = {
        ring.instance_addr = constants.localhost.ip;
        ring.kvstore.store = "inmemory";
        replication_factor = 1;
        path_prefix = "/tmp/loki";
      };
      schema_config.configs = [{
        schema = "v13";
        from = "2020-05-15";
        store = "tsdb";
        object_store = "filesystem";
        index.prefix = "index_";
        index.period = "24h";
      }];
      storage_config.filesystem.directory = "/var/lib/loki/chunks";
    };
  };
}
