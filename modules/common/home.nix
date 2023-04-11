{ config, scope, machine-name, ... }: with scope;
{
  imports = [
    (machines.${machine-name}.home or { })
    modules.home.misc
    modules.home.git
    modules.home.bash
    modules.home.packages
  ];
  _module.args = {
    isNixOS = hasAttr machine-name nixosConfigurations;
    isGraphical = !elem machine-name [ "kwbauson" ];
  };
  home.username = mkDefault (if !isDarwin then "keith" else "keithbauson");
  home.homeDirectory = mkDefault "/${if !isDarwin then "home" else "Users"}/${config.home.username}";
}
