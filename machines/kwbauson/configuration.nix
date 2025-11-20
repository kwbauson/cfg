{ config, scope, ... }: with scope;
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  time.timeZone = "America/Chicago";

  services.tailscale.useRoutingFeatures = "both";
  networking = with constants; {
    networkmanager.enable = false;
    inherit (kwbauson) domain;
    firewall.allowedTCPPorts = [ http.port https.port ];
    firewall.allowedUDPPorts = config.networking.firewall.allowedTCPPorts;
  };
  services._3proxy.enable = true;

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

  services.auto-update.enable = true;

  systemd.services.notify-usage = {
    startAt = "*-*-* 06:00:00";
    path = [ curl coreutils ];
    script = ''
      curl -d "$(df -h /dev/vda1 --output=pcent | tail -n1)" https://ntfy.kwbauson.com/kwbauson-usage
    '';
  };
}
