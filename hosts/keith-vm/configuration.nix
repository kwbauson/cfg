{ lib, ... }:
with builtins;
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  hardware.pulseaudio.enable = true;
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtime.enable = lib.mkForce false;
  services.xserver.enable = true;

  virtualisation.docker.enable = true;
}

