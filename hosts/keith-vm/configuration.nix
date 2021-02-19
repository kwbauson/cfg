{ pkgs, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (self.lib.callModule ../common.nix)
  ];

  networking.hostName = "keith-vm";
  networking.interfaces.enp0s5.useDHCP = true;
  networking.firewall.enable = false;
  services.xserver.enable = true;
  hardware.pulseaudio.enable = true;
  virtualisation.docker.enable = true;
  programs.steam.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.sshd.enable = true;
  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      listen = [{ addr = "127.0.0.1"; port = 8000; }];
      locations = {
        "/".proxyPass = "http://127.0.0.1:7999";
        "~ ^/(?:api|internal|lms|launch|users/lti_login)(/.*|$)".proxyPass = "http://127.0.0.1:3000";
      };
    };
  };
}
