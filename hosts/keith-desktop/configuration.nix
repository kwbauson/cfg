{ lib, pkgs, ... }:
with builtins;
{
  imports = [
    ./hardware-configuration.nix
  ];

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtime.enable = lib.mkForce false;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation.docker.enable = true;
  hardware = {
    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
  };
  environment.systemPackages = [ pkgs.xboxdrv ];
}

