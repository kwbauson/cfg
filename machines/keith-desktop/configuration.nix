{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.initrd.enable = false;

  virtualisation.docker.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  networking.extraHosts = "127.0.0.1 api";
  services.evremap.enable = true;
  services.evremap.settings.device_name = "Corsair Corsair Gaming K68 Keyboard";
}
