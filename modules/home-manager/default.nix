{ config, scope, ... }: with scope;
{
  imports = [
    (machine.home or { })
  ] ++ attrValues (importDir ./.);

  home.username = mkDefault username;
  home.homeDirectory = mkDefault "/${if !isDarwin then "home" else "Users"}/${config.home.username}";
}
