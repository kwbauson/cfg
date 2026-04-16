{ config, scope, machine-name, username, ... }: with scope;
{
  imports = [
    modules.args
    (machines.${machine-name}.home or { })
  ] ++ attrValues (importDir ./.);

  home.username = mkDefault username;
  home.homeDirectory = mkDefault "/${if !isDarwin then "home" else "Users"}/${config.home.username}";
}
