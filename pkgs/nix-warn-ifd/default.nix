scope: with scope;
nix.overrideAttrs (old: {
  patches = old.patches or [ ] ++ [ ./warn-ifd.patch ];
  doCheck = false;
})
