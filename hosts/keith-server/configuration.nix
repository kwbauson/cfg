{ lib, pkgs, self, ... }:
with builtins;
{
  imports = with self.inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-cpu-amd
    common-gpu-amd
    common-cpu-amd-pstate
  ];

  nix.settings.trusted-users = [ "@wheel" ];
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 3;
  hardware.amdgpu.loadInInitrd = false;

  time.hardwareClockInLocalTime = true;
  time.timeZone = "America/Indianapolis";

  services.localtimed.enable = false;
  services.xserver.enable = true;
  virtualisation.docker.enable = true;
  users.users.keith.extraGroups = [ "dialout" ];
  services.tailscale.enable = true;
  services.openssh.enable = true;

  services.github-runner = {
    enable = true;
    extraLabels = [ "nix" ];
    tokenFile = "/etc/nixos/github-runner-token";
    url = "https://github.com/kwbauson/cfg";
  };
}
