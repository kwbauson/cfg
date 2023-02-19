{ scope, ... }: with scope;
{
  users.users = mkForce {
    benjamin.home = "/Users/benjamin";
  };
  home-manager.users = mkForce {
    benjamin.imports = [ modules.common.home ];
  };
}
