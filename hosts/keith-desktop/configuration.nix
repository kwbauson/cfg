{ lib, pkgs, nixos-hardware, self, ... }:
with builtins;
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-amd
    # nixos-hardware.nixosModules.common-gpu-nvidia
    ./hardware-configuration.nix
    (self.lib.callModule ../common.nix)
  ];

  boot.loader.timeout = lib.mkForce 10;

  hardware.pulseaudio.enable = true;

  services.autorandr.enable = true;
  services.xserver.enable = true;
  programs.steam.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
}
