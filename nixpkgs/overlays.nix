{ _auto, scope }: with scope;
[
  (_: prev: forAttrs
    (root.pkgs prev.stdenv.hostPlatform.system).overlayFns
    (name: fn: fn prev.${name})
  )
]
