{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    networkmanager.enable = false;
    interfaces.enp3s0.ipv4.addresses = [{ address = "208.87.134.252"; prefixLength = 24; }];
    defaultGateway.address = "208.87.134.1";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    domain = "com";
    firewall.allowedTCPPorts = [ 2456 2457 2458 4443 80 443 ];
    firewall.allowedUDPPorts = [ 2456 2457 2458 10000 ];
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  programs.steam.enable = false;

  services.caddy.enable = true;
  services.caddy.email = "kwbauson@gmail.com";
  services.caddy.virtualHosts = with config.networking; {
    ${fqdn}.extraConfig = "reverse_proxy keith-server:11337";
    "files.${fqdn}".extraConfig = "reverse_proxy keith-server:18080";
    "netdata.${fqdn}".extraConfig = "reverse_proxy keith-server:19999";
    "jitsi.${fqdn}".extraConfig = "reverse_proxy keith-server:15280";
  };

  systemd.services.forward-ports = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.socat ];
    script = ''
      # valheim
      for port in 2456 2457 2458;do
        for proto in TCP UDP;do
          socat $proto-LISTEN:$port,fork,reuseaddr $proto:keith-server:$port &
        done
      done
      # jitsi
      socat TCP-LISTEN:4443,fork,reuseaddr TCP:keith-server:4443 &
      socat UDP-LISTEN:10000,fork,reuseaddr UDP:keith-server:10000 &
      sleep inf
    '';
  };
}
