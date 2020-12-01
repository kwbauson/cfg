with import ./flake-compat.nix;
{
  recurseForDerivations = true;

  nixosConfigurations = with nixosConfigurations; {
    keith-xps = nixosConfigurations.keith-xps.drv;
    kwbauson = nixosConfigurations.kwbauson.drv;
    keith-vm = nixosConfigurations.keith-vm.drv;
  };

  homeConfigurations = with homeConfigurations; {
    inherit non-graphical graphical;
  };
}
