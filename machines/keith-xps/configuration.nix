{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    dell-xps-13-9350
  ];
  machine.tailscale-ip = "100.92.188.49";
  services.evremap.enable = true;
  services.evremap.settings.device_name = "AT Translated Set 2 keyboard";
  services.evremap.settings.remap = [{ input = [ "KEY_RIGHTCTRL" ]; output = [ "KEY_RIGHTMETA" ]; }];
}
