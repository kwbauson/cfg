{ pkgs, nixos-hardware, self, ... }:
with builtins;
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    ./hardware-configuration.nix
    (self.lib.callModule ../common.nix)
  ];

  hardware.pulseaudio.enable = true;

  networking = {
    hostName = "keith-desktop";
    networkmanager.enable = true;
  };
  services.autorandr.enable = true;
  services.xserver.enable = true;
  programs.steam.enable = true;
}
