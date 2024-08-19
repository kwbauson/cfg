{ config, scope, ... }: with scope;
{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  services.tailscale.useRoutingFeatures = "both";
  networking = with constants; {
    networkmanager.enable = false;
    inherit (kwbauson) domain;
    firewall.allowedTCPPorts = [ http.port https.port ];
    firewall.allowedUDPPorts = config.networking.firewall.allowedTCPPorts;
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

  services.auto-update.enable = true;
}
