{ scope, ... }: with scope;
{
  options.machine = mkOption {
    type = types.raw;
    internal = true;
    visible = false;
    apply = _: throw "machine module is write-only";
  };
}
