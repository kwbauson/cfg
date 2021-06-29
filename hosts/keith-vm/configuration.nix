{ ... }:
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

  services.autorandr.enable = true;
  services.xserver.enable = true;
}


