{ scope, machine, ... }: with scope;
{
  options.machine = mkOption {
    type = types.raw;
    internal = true;
    visible = false;
  };

  config._module.args = {
    inherit (machine) isNixOS isNixDarwin username isGraphical isMinimal;
  };
}
