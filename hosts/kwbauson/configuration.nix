{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/olivetin.nix
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
    firewall.allowedTCPPorts = [ 80 443 2456 2457 ];
    firewall.allowedUDPPorts = [ 2456 2457 ];
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
    forwardX11 = true;
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
    ];
    ciphers = [
      "chacha20-poly1305@openssh.com"
      "aes256-gcm@openssh.com"
      "aes256-ctr"
    ];
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };
  services.nginx = with config.networking; {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = builtins.mapAttrs (_: x: x // { enableACME = true; forceSSL = true; }) {
      ${fqdn} = {
        basicAuthFile = "/etc/nixos/authfile";
        locations."/".proxyPass = "http://localhost:1337";
      };
      "files.${fqdn}".locations."/" = {
        root = "/srv/files";
        extraConfig = "autoindex on;";
      };
      "netdata.${fqdn}".locations."/".proxyPass = "http://localhost:19999";
    };
  };
  services.jitsi-meet = with config.networking; {
    enable = true;
    hostName = "jitsi.${fqdn}";
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
  services.netdata.enable = true;
  services.github-runner = {
    enable = true;
    extraLabels = [ "nix" ];
    extraPackages = with pkgs; [ cachix ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };

  systemd.services.prosody.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jicofo.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jitsi-meet-init-secrets.restartTriggers = [ pkgs.jitsi-meet ];
  systemd.services.jitsi-videobridge2.restartTriggers = [ pkgs.jitsi-meet ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "kwbauson@gmail.com";
  };

  virtualisation.docker.enable = true;
  programs.steam.enable = false;
  virtualisation.oci-containers.containers.valheim = {
    autoStart = false;
    image = "ghcr.io/lloesche/valheim-server";
    environmentFiles = [ /var/lib/valheim/environment ];
    extraOptions = [ "--cap-add=sys_nice" "--stop-timeout=120" ];
    ports = [ "2456-2457:2456-2457/udp" ];
    volumes = [ "/var/lib/valheim:/config" ];
  };
}
