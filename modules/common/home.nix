{ config, scope, machine-name, ... }: with scope;
{
  imports = [
    (machines.${machine-name}.home or { })
    modules.home-old
  ];
  home.username = mkDefault "keith";
  home.homeDirectory = mkDefault "/${if isDarwin then "Users" else "home"}/${config.home.username}";
}
