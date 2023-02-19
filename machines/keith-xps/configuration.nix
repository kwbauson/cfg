{ scope, ... }: with scope;
{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-laptop
    common-pc-laptop-ssd
  ];

  boot.blacklistedKernelModules = [ "psmouse" ];
}
