{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    ./hardware-configuration.nix
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  boot.blacklistedKernelModules = [ "psmouse" ];
  hardware.bluetooth.enable = true;
  networking.networkmanager.wifi.powersave = false;
  services.xserver.enable = true;

  users.mutableUsers = false;
  users.users.keith.passwordFile = "/etc/nixos/secrets/keith-password";
  users.users.root.passwordFile = "/etc/nixos/secrets/root-password";
  programs.steam.enable = true;
}
