{ config, scope, machine-name, ... }: with scope;
{
  imports = [
    (machines.${machine-name}.home or { })
    modules.home-old
  ];
  home.username = mkDefault (if !isDarwin then "keith" else "keithbauson");
  home.homeDirectory = mkDefault "/${if !isDarwin then "home" else "Users"}/${config.home.username}";
}
