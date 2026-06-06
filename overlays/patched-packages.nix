final: prev: with prev.scope';
mapDirEntries
  (n: value: optionalAttrs (hasSuffix ".patch" n) rec {
    name = removeSuffix ".patch" n;
    value = prev.${name}.overrideAttrs (old: { patches = old.patches or [ ] ++ [ (../pkgs + ("/" + n)) ]; });
  }) ../pkgs
