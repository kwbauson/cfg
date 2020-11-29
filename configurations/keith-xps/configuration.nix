{ pkgs, ... }:
with builtins;
{
  imports =
    let
      cfg = import ../../flake-compat.nix;
      nixos-hardware = cfg.inputs.nixos-hardware;
    in
    [
      nixos-hardware.nixosModules.common-cpu-intel
      nixos-hardware.nixosModules.common-pc-laptop
      nixos-hardware.nixosModules.common-pc-laptop-ssd
      ./hardware-configuration.nix
      ../common.nix
    ];

  boot.blacklistedKernelModules = [ "psmouse" ];
  nixpkgs.config.pulseaudio = true;
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;

    pulseaudio = {
      enable = true;
      extraConfig = "load-module module-switch-on-connect";
    };

    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;
  };
  networking = {
    hostName = "keith-xps";
    networkmanager.enable = true;
    networkmanager.wifi.powersave = false;
  };
  services.autorandr.enable = true;
  services.xserver.enable = true;

  users.mutableUsers = false;
  users.users.keith.hashedPassword = readFile /etc/nixos/secrets/keith-password;
  users.users.root.hashedPassword = readFile /etc/nixos/secrets/root-password;
  programs.steam.enable = true;
}
