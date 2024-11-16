{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    dell-xps-13-9350
  ];
  services.tailscale.enable = true;
  services.evremap.enable = true;
  services.evremap.settings.device_name = "AT Translated Set 2 keyboard";
}
