final: prev: with prev.scope-lib; let
  extra-packages = mapAttrs
    (n: f: prev.scope.callPackage f (prev.scope // rec {
      name = "${pname}-${version}";
      pname = n;
      version = src.version or src.rev or "unversioned";
      src = prev.scope.sources.${n} or null;
      ${n} = prev.${n};
    }))
    (filterAttrs (_: v: !isPath v) (import' ../pkgs));
in
{ inherit extra-packages; } // extra-packages
