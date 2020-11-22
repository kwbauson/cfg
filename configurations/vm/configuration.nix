{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  networking = {
    hostName = "keith-vm";
    interfaces.enp0s5.useDHCP = true;
  };

  fonts.enableDefaultFonts = true;
  services.xserver.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.keith.extraGroups = [ "wheel" "docker" ];
  # hardware.parallels.enable = true;
  virtualisation.docker.enable = true;
}
