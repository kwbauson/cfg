{ scope, machine-name, ... }: with scope;
{
  _module.args = let machine = machines.${machine-name}; in {
    username = mkDefault machine.username or "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = mkDefault machine.isGraphical or true;
    isMinimal = mkDefault machine.isGraphical or false;
  };
}
