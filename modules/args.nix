{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isGraphical = !elem machine-name [ "kwbauson" ];
    isNixOS = hasAttr machine-name nixosConfigurations;
    isMinimal = elem machine-name [ "kwbauson" ];
  };
}
