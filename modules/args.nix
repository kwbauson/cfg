{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = mkDefault machines.${machine-name}.partial._module.args.isGraphical or true;
    isMinimal = mkDefualt machines.${machine-name}.partial._module.args.isGraphical or false;
  };
}
