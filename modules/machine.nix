{ scope, machine, ... }: with scope;
{
  options.machine = mkOption {
    type = types.raw;
    internal = true;
    visible = false;
  };

  config._module.args = {
    inherit (machine) isNixOS isNixDarwin;
    username = mkDefault machine.username or "keith";
    isGraphical = mkDefault machine.isGraphical or true;
    isMinimal = mkDefault machine.isGraphical or false;
  };
}
