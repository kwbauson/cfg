{ _auto, scope }: with scope;
[
  (_: prev: pipeValue [
    (readDir ../pkgs)
    (filterAttrs (n: _: hasSuffix ".patch" n))
    (mapAttrs' (n: _: rec {
      name = removeSuffix ".patch" n;
      value = prev.${name}.overrideAttrs (old: { patches = old.patches or [ ] ++ [ ../pkgs/${n} ]; });
    }))
  ])
]
