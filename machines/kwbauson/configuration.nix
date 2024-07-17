{ scope, ... }: with scope;
let
  forwardedTCPPorts = [ 2456 2457 ];
  forwardedUDPPorts = [ 2456 2457 ];
in
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
    firewall.allowedTCPPorts = [ http.port https.port ] ++ forwardedTCPPorts;
    firewall.allowedUDPPorts = forwardedUDPPorts;
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
    script = ''
      for port in ${toString forwardedTCPPorts};do
        socat TCP-LISTEN:"$port",fork,reuseaddr TCP:keith-server:"$port" &
      done
      for port in ${toString forwardedUDPPorts};do
        socat UDP-RECVFROM:"$port",fork,reuseaddr UDP-SENDTO:keith-server:"$port" &
      done
      sleep inf
    '';
  };

  services.auto-update.enable = true;
}
