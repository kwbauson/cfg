{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = partialConfigs.${machine-name}._module.args.isGraphical or true;
    isMinimal = partialConfigs.${machine-name}._module.args.isGraphical or false;
  };
}
