{ scope, machine-name, ... }: with scope;
{
  _module.args = {
    username = lib.mkDefault "keith";
    isNixOS = hasAttr machine-name nixosConfigurations;
    # TODO figure out a clean way to get these in machine configs
    isGraphical = !elem machine-name [ "kwbauson" ];
    isMinimal = elem machine-name [ "kwbauson" ];
  };
}
