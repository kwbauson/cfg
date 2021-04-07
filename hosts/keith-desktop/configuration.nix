{ nixos-hardware, ... }:
with builtins;
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    ./hardware-configuration.nix
  ];

  hardware.pulseaudio.enable = true;
  time.hardwareClockInLocalTime = true;

  services.autorandr.enable = true;
  services.xserver.enable = true;
  programs.steam.enable = true;
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
}
