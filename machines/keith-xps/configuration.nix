{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    dell-xps-9350
  ];
}
