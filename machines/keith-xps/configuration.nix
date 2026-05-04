{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    dell-xps-13-9350
  ];
  machine.tailscale-ip = "100.92.188.49";
  services.keyd.enable = true;
  services.keyd.keyboards.default.ids = [ "0001:0001:093d12dc" ];
  services.keyd.keyboards.default.settings.main.rightcontrol = "rightmeta";
}
