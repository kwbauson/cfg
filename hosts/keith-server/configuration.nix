{ config, pkgs, self, ... }:
with builtins;
{
  imports = with self.inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
    ../../modules/olivetin.nix
  ];

  nix.settings.trusted-users = [ "@wheel" ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.loadInInitrd = false;

  networking = {
    firewall.allowedTCPPorts = [ 2456 2457 2458 11337 19999 18080 15280 ];
    firewall.allowedUDPPorts = [ 2456 2457 2458 ];
  };

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtimed.enable = false;
  services.xserver.enable = true;
  virtualisation.docker.enable = true;
  users.users.keith.extraGroups = [ "dialout" ];
  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.github-runner = {
    enable = true;
    extraLabels = [ "nix" ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  virtualisation.oci-containers.containers.valheim = {
    autoStart = true;
    image = "ghcr.io/lloesche/valheim-server";
    environmentFiles = [ /var/lib/valheim/environment ];
    extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
    ports = [ "2456-2457:2456-2457/udp" ];
    volumes = [ "/var/lib/valheim:/config" ];
  };

  systemd.tmpfiles.rules = [ "d /srv/files 777" ];

  services.caddy.enable = true;
  services.caddy.virtualHosts = {
    ":11337".extraConfig = ''
      basicauth /* {
        {$OLIVETIN_USERNAME} {$OLIVETIN_HASHED_PASSWORD}
      }
      reverse_proxy localhost:1337
    '';
    ":18080".extraConfig = ''
      file_server browse {
        root /srv/files
      }
    '';
  };
  systemd.services.caddy.serviceConfig.EnvironmentFile = "/etc/nixos/caddy-environment";
}
