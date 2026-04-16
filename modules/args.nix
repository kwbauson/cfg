{ scope, machine-name, ... }: with scope;
{
  _module.args = let machine = machines.${machine-name}; in {
    inherit machine;
    inherit (machine) isNixOS isNixDarwin;
    username = mkDefault machine.username or "keith";
    isGraphical = mkDefault machine.isGraphical or true;
    isMinimal = mkDefault machine.isGraphical or false;
  };
}
