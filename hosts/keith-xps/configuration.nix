{ pkgs, lib, nixos-hardware, ... }:
with builtins;
{
  imports = [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-laptop
    nixos-hardware.nixosModules.common-pc-laptop-ssd
    ./hardware-configuration.nix
  ];

  boot.blacklistedKernelModules = [ "psmouse" ];
  hardware = {
    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
  };
  networking.networkmanager.wifi.powersave = false;
  services.xserver.enable = true;

  users.mutableUsers = false;
  users.users.keith.passwordFile = "/etc/nixos/secrets/keith-password";
  users.users.root.passwordFile = "/etc/nixos/secrets/root-password";
  programs.steam.enable = true;
}
