{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = mkDefault machines.${machine-name}.isGraphical or true;
    isMinimal = mkDefault machines.${machine-name}.isGraphical or false;
  };
}
