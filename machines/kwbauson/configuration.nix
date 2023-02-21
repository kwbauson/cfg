{ config, scope, ... }: with scope;
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = with constants; {
    networkmanager.enable = false;
    interfaces.enp3s0.ipv4.addresses = [{ address = kwbauson.ip; prefixLength = 24; }];
    defaultGateway.address = kwbauson.gateway;
    nameservers = cloudflare-dns.ips;
    inherit (kwbauson) domain;
    firewall.allowedTCPPorts = [ http.port https.port jitsi.tcp-port ] ++ valheim.ports;
    firewall.allowedUDPPorts = [ jitsi.udp-port ] ++ valheim.ports;
    # firewall.checkReversePath = false;
    firewall.trustedInterfaces = [ "tailscale0" ];
    # nat.enable = true;
    # nat.externalIP = kwbauson.ip;
    # nat.internalIPs = [ keith-server.ip ];
    # nat.externalInterface = "enp3s0";
    # nat.internalInterfaces = [ "tailscale0" ];
    # nat.forwardPorts =
    #   map (port: { proto = "tcp"; sourcePort = port; destination = "${keith-server.ip}:${toString port}"; })
    #     ([ jitsi.tcp-port ] ++ valheim.ports) ++
    #   map (port: { proto = "udp"; sourcePort = port; destination = "${keith-server.ip}:${toString port}"; })
    #     ([ jitsi.udp-port ] ++ valheim.ports);
  };

  services.openssh.enable = true;
  services.xserver.enable = false;

  services.caddy.enable = true;
  services.caddy.virtualHosts = with constants; with config.networking; {
    ${fqdn}.extraConfig = "reverse_proxy keith-server:${toString olivetin.authed-port}";
    "files.${fqdn}".extraConfig = "reverse_proxy keith-server:${toString file-server.port}";
    "netdata.${fqdn}".extraConfig = "reverse_proxy keith-server:${toString netdata.port}";
    "jitsi.${fqdn}".extraConfig = "reverse_proxy keith-server:${toString jitsi.caddy-port}";
  };

  systemd.services.forward-ports = {
    wantedBy = [ "multi-user.target" ];
    path = [ socat ];
    script = ''
      # valheim
      for port in 2456 2457;do
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
