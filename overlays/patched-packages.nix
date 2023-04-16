final: prev: with prev.scope-lib;
mapDirEntries
  (n: value: optionalAttrs (hasSuffix ".patch" n) rec {
    name = removeSuffix ".patch" n;
    value = override prev.${name} { patches = [ (../pkgs + ("/" + n)) ]; };
  }) ../pkgs
