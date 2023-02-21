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
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.extraCommands = concatMapStringsSep "\n"
      ({ port, proto }: "iptables -t nat -A POSTROUTING -d ${keith-server.ip} -p ${proto} -m ${proto} --dport ${toString port} -j MASQUERADE")
      (
        (map (port: { proto = "tcp"; inherit port; }) (remove ssh.port config.networking.firewall.allowedTCPPorts)) ++
        (map (port: { proto = "udp"; inherit port; }) config.networking.firewall.allowedUDPPorts)
      );
    nat.enable = true;
    nat.externalInterface = "enp3s0";
    nat.forwardPorts =
      map (port: { proto = "tcp"; sourcePort = port; destination = "${keith-server.ip}:${toString port}"; })
        (remove ssh.port config.networking.firewall.allowedTCPPorts) ++
      map (port: { proto = "udp"; sourcePort = port; destination = "${keith-server.ip}:${toString port}"; })
        config.networking.firewall.allowedUDPPorts;
  };

  services.openssh.enable = true;
  services.xserver.enable = false;
}
