{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 1w";
  };

  boot.tmpOnTmpfs = lib.mkForce false;

  networking = {
    networkmanager.enable = lib.mkForce false;
    interfaces.enp3s0.ipv4.addresses = [{ address = "208.87.134.252"; prefixLength = 24; }];
    defaultGateway.address = "208.87.134.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    domain = "com";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services = with config; with networking; {
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = builtins.mapAttrs (_: x: x // { enableACME = true; forceSSL = true; }) {
        ${fqdn} = {
          locations."/" = {
            root = "/srv/files";
            extraConfig = "autoindex on;";
          };
        };
        "cache.${fqdn}".locations."/".proxyPass = with services.nix-serve; "http://${bindAddress}:${toString port}";
        "netdata.${fqdn}".locations."/".proxyPass = "http://localhost:19999";
      };
    };
    jitsi-meet = {
      enable = true;
      hostName = "jitsi.${fqdn}";
      config.enableNoisyMicDetection = false;

      interfaceConfig = {
        SHOW_JITSI_WATERMARK = false;
        SHOW_WATERMARK_FOR_GUESTS = false;
        # MOBILE_APP_PROMO = false;
      };
    };
    jitsi-videobridge.openFirewall = true;
    github-runner = {
      enable = true;
      tokenFile = "/etc/nixos/self-hosted-runner-token";
      url = "https://github.com/kwbauson/cfg";
      extraPackages = with pkgs; [ gh ];
    };
    nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nixos/cache-priv-key.pem";
    };
    netdata.enable = true;
  };

  security.acme = {
    acceptTerms = true;
    email = "kwbauson@gmail.com";
  };

  virtualisation.docker.enable = true;

  # undoing https://github.com/NixOS/nixpkgs/commit/ac7b8724b59974c0d74f2feacc4a2a787a5cf122
  systemd.services.nix-serve.serviceConfig.Group = lib.mkForce "nogroup";
  systemd.services.nix-serve.serviceConfig.DynamicUser = lib.mkForce "false";
  users.users.nix-serve = {
    description = "Nix-serve user";
    uid = 199;
  };
}
