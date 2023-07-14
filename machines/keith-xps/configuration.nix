{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    dell-xps-13-9350
  ];
  services.tailscale.enable = true;
}
