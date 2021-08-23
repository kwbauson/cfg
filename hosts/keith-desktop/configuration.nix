{ lib, ... }:
with builtins;
{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.pulseaudio.enable = true;
  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtime.enable = lib.mkForce false;
  services.xserver.enable = true;

  virtualisation.docker.enable = true;
}

