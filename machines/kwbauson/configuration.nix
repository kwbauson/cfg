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
    interfaces.enp3s0.ipv6.addresses = [{ address = kwbauson.ip6; prefixLength = 24; }];
    defaultGateway.address = kwbauson.gateway;
    nameservers = cloudflare-dns.ips;
    inherit (kwbauson) domain;
    firewall.allowedTCPPorts = [ http.port https.port jitsi.tcp-port ] ++ valheim.ports;
    firewall.allowedUDPPorts = [ jitsi.udp-port ] ++ valheim.ports;
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.extraCommands = concatMapStringsSep "\n"
      (x: "iptables -t nat -A POSTROUTING -d ${x.destination} -p ${x.proto} -m ${x.proto} --dport ${toString x.sourcePort} -j MASQUERADE")
      config.networking.nat.forwardPorts;
    nat.enable = true;
    nat.enableIPv6 = true;
    nat.externalInterface = "enp3s0";
    nat.forwardPorts =
      map (port: { proto = "tcp"; sourcePort = port; destination = keith-server.ip; })
        ([ jitsi.tcp-port ] ++ valheim.ports) ++
      map (port: { proto = "udp"; sourcePort = port; destination = keith-server.ip; })
        ([ jitsi.udp-port ] ++ valheim.ports);
  };

  services.openssh.enable = true;
  services.xserver.enable = false;

  services.caddy.enable = true;
  services.caddy.virtualHosts = with constants; {
    "${kwbauson.fqdn}".extraConfig = "reverse_proxy keith-server:${toString olivetin.authed-port}";
    "files.${kwbauson.fqdn}".extraConfig = "reverse_proxy keith-server:${toString file-server.port}";
    "netdata.${kwbauson.fqdn}".extraConfig = "reverse_proxy keith-server:${toString netdata.port}";
    "jitsi.${kwbauson.fqdn}".extraConfig = "reverse_proxy keith-server:${toString jitsi.caddy-port}";
  };
}
