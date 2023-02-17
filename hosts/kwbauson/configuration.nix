{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  fileSystems."/".options = [ "barrier=0" "data=writeback" "commit=60" "noatime" ];

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
    firewall.allowedTCPPorts = [ 2456 2457 2458 80 443 ];
    firewall.allowedUDPPorts = [ 2456 2457 2458 ];
  };

  services.openssh.enable = true;
  services.tailscale.enable = true;
  programs.steam.enable = false;

  services.jitsi-meet = {
    enable = true;
    nginx.enable = false;
    caddy.enable = true;
    hostName = "jitsi.${config.networking.fqdn}";
    config.enableNoisyMicDetection = false;
    config.p2p.enabled = false;
    config.disableTileEnlargement = true;
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
      # MOBILE_APP_PROMO = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
  # services.jitsi-videobridge.config.videobridge.cc.trust-bwe = false;

  systemd.services.prosody.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jicofo.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jitsi-meet-init-secrets.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jitsi-videobridge2.restartTriggers = [ pkgs.jitsi-meet ];

  services.caddy.enable = true;
  services.caddy.email = "kwbauson@gmail.com";
  services.caddy.virtualHosts = with config.networking; {
    ${fqdn}.extraConfig = "reverse_proxy keith-server:11337";
    "files.${fqdn}".extraConfig = "reverse_proxy keith-server:18080";
    "netdata.${fqdn}".extraConfig = "reverse_proxy keith-server:19999";
  };

  systemd.services.forward-valheim = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.socat ];
    script = ''
      for port in 2456 2457 2458;do
        for proto in TCP UDP;do
          socat $proto-LISTEN:$port,fork,reuseaddr $proto:keith-server:$port &
        done
      done
      sleep inf
    '';
  };
}
