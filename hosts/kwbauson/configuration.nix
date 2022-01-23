{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./olivetin.nix
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    networkmanager.enable = lib.mkForce false;
    interfaces.enp3s0.ipv4.addresses = [{ address = "208.87.134.252"; prefixLength = 24; }];
    defaultGateway.address = "208.87.134.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 ];
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
    config.p2p.enabled = true;
    interfaceConfig = {
      SHOW_JITSI_WATERMARK = false;
      SHOW_WATERMARK_FOR_GUESTS = false;
      # MOBILE_APP_PROMO = false;
    };
  };
  services.jitsi-videobridge.openFirewall = true;
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
}
