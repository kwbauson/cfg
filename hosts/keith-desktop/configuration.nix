{ pkgs, self, ... }:
with builtins;
{
  imports = with self.inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-cpu-amd
    common-gpu-amd
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 2;

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtimed.enable = false;
  services.xserver.enable = true;
  hardware.nvidia.nvidiaSettings = false;
  virtualisation.docker.enable = true;
  hardware.bluetooth.enable = true;
  environment.systemPackages = [ pkgs.xboxdrv ];
  users.users.keith.extraGroups = [ "dialout" ];
  services.tailscale.enable = true;
  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };
}
