{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
  ];

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.loadInInitrd = false;
  time.hardwareClockInLocalTime = true;

  services.openssh.enable = true;
  virtualisation.docker.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  services.openssh.settings.PermitRootLogin = mkForce "yes";
  networking.extraHosts = "127.0.0.1 api";
}
