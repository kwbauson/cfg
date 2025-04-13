scope: with scope;
nix.overrideAttrs (old: {
  inherit pname;
  patches = old.patches or [ ] ++ [ ./warn-ifd.patch ];
  passthru = { };
})
