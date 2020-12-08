{ pkgs, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    (self.lib.callModule ../common.nix)
  ];

  networking.hostName = "keith-vm";
  networking.interfaces.enp0s5.useDHCP = true;
  services.xserver.enable = true;
  hardware.pulseaudio.enable = true;
  virtualisation.docker.enable = true;
  programs.steam.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
