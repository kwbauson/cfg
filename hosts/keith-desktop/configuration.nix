{ pkgs, ... }:
with builtins;
{
  imports = [
    ./hardware-configuration.nix
  ];

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtimed.enable = false;
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.nvidiaSettings = false;
  hardware.nvidia.package = pkgs.linuxPackages.callPackage
    ({ callPackage, pkgsi686Linux }:
      let
        imported = import "${pkgs.path}/pkgs/os-specific/linux/nvidia-x11/generic.nix" {
          version = "510.68.02";
          sha256_64bit = "sha256-vSw0SskrL8ErBgQ1kKT+jU6wzLdNDEk1LwBM8tKZ9MU=";
          settingsSha256 = "sha256-4TBA/ITpaaBiVDkpj7/Iydei1knRPpruPL4fRrqFAmU=";
          persistencedSha256 = "sha256-Q1Rk6dAK4pnm6yDK4kmj5Vg4GRbi034C96ypywHYB2I=";
        };
      in
      callPackage imported {
        lib32 = (pkgsi686Linux.callPackage imported {
          libsOnly = true;
          kernel = null;
        }).out;
      })
    { };

  virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  environment.systemPackages = [ pkgs.xboxdrv ];
  users.users.keith.extraGroups = [ "dialout" ];
  services.tailscale.enable = true;
}
