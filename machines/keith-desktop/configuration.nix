{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
  ];

  machine.tailscale.ip = "100.82.72.117";
  machine.public.key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIiFgQqHtbb63VIn4ZloBZkCRtRl2teWb2bBH8ev7/iN keith@keith-desktop";
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  virtualisation.docker.enable = true;
  services.hardware.openrgb.enable = true;
  services.hardware.openrgb.motherboard = "amd";

  services.keyd.enable = true;
  services.keyd.keyboards.default.ids = [ "1b1c:1b3f:bee979b7" ];
}
