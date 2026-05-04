{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
  ];

  machine.tailscale-ip = "100.82.72.117";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.initrd.enable = false;

  virtualisation.docker.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  services.keyd.enable = true;
  services.keyd.keyboards.default.ids = [ "1b1c:1b3f:bee979b7" ];
}
