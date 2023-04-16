{ config, scope, ... }: with scope;
let
  pkgs-type = types.oneOf [
    types.package
    (types.listOf pkgs-type)
    (types.attrsOf pkgs-type)
  ];
  drvs = x: if isDerivation x || isList x then flatten x else flatten (mapAttrsToList (_: v: drvs v) x);
  drvsExcept = x: e: flatten (drvs (filterAttrsRecursive (n: _: !elem n (attrNames e)) x));
in
{
  options = {
    included-packages = mkOption {
      type = pkgs-type;
      default = { };
    };
    excluded-packages = mkOption {
      type = types.attrsOf types.package;
      default = { };
    };
  };
  config.home.packages = drvsExcept config.included-packages config.excluded-packages;
}
