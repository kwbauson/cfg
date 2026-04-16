{ scope, machine, ... }: with scope;
{
  _module.args = {
    inherit (machine) isNixOS isNixDarwin;
    username = mkDefault machine.username or "keith";
    isGraphical = mkDefault machine.isGraphical or true;
    isMinimal = mkDefault machine.isGraphical or false;
  };
}
