{ config, scope, ... }: with scope;
{
  machine.isGraphical = false;
  machine.isMinimal = true;
  machine.tailscale.ip = "100.89.245.93";
  machine.public.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJtcd3xL1BR1RSFzin0Im+HUk6kTWj44wJ56uWxkPM0 keith@kwbauson";
  machine.public.ip = "137.220.57.226";
  machine.public.fqdn = "kwbauson.com";
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  time.timeZone = "America/Chicago";

  services.tailscale.useRoutingFeatures = "both";
  networking = with constants; {
    networkmanager.enable = false;
    firewall.allowedTCPPorts = [ http.port https.port ];
    firewall.allowedUDPPorts = config.networking.firewall.allowedTCPPorts;
  };
  services._3proxy.enable = true;
  services.smartd.enable = false;

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
}
