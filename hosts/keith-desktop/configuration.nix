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
  hardware.nvidia.nvidiaSettings = false;

  virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  environment.systemPackages = [ pkgs.xboxdrv ];
  users.users.keith.extraGroups = [ "dialout" ];
  services.tailscale.enable = true;

  # fix slow vulkan from nixpkgs/1da4e07ea68c1782f11889f507d3e923d6b9ad85. hopefully will delete in near future
  hardware.opengl.extraPackages = [
    (pkgs.runCommand "nvidia-icd" { } ''
      mkdir -p $out/share/vulkan/icd.d
      cp ${pkgs.linuxPackages.nvidia_x11}/share/vulkan/icd.d/nvidia_icd.x86_64.json $out/share/vulkan/icd.d/nvidia_icd.json
    '')
  ];
}
