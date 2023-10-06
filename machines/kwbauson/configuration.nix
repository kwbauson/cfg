{ scope, ... }: with scope;
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
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
  };

  services.openssh.openFirewall = mkForce true;
  services.xserver.enable = false;

  services.caddy = with constants; {
    enable = true;
    globalConfig = ''
      on_demand_tls {
        ask http://keith-server:${toString on-demand-tls.port}
      }
    '';

    extraConfig = ''
      https:// {
        tls {
          on_demand
        }
        reverse_proxy keith-server:${toString http.port}
      }
    '';
  };

  systemd.services.forward-ports = {
    wantedBy = [ "multi-user.target" ];
    path = [ socat ];
    script = with constants; ''
      # valheim
      # for port in ${toString valheim.ports};do
      #   for proto in TCP UDP;do
      #     socat $proto-LISTEN:$port,fork,reuseaddr $proto:keith-server:$port &
      #   done
      # done
      # jitsi
      socat TCP-LISTEN:${toString jitsi.tcp-port},fork,reuseaddr TCP:keith-server:${toString jitsi.tcp-port} &
      socat UDP-LISTEN:${toString jitsi.udp-port},fork,reuseaddr UDP:keith-server:${toString jitsi.udp-port} &
      sleep inf
    '';
  };

  services.auto-update.enable = true;
}
