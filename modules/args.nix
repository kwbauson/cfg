{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = mkDefault partialConfigs.${machine-name}.isGraphical or true;
    isMinimal = mkDefault partialConfigs.${machine-name}.isGraphical or false;
  };
}
