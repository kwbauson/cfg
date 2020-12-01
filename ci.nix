with import ./flake-compat.nix;
{
  nixosConfigurations-keith-xps = nixosConfigurations.keith-xps.drv;
  nixosConfigurations-kwbauson = nixosConfigurations.kwbauson.drv;
  nixosConfigurations-keith-vm = nixosConfigurations.keith-vm.drv;

  homeConfigurations-non-graphical = homeConfigurations.non-graphical;
  homeConfigurations-graphical = homeConfigurations.graphical;
}
