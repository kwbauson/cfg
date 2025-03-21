scope: with scope;
nix.overrideAttrs (old: {
  inherit pname;
  patches = old.patches or [ ] ++ [ ./warn-ifd.patch ];
  doCheck = false;
  passthru = { };
  outputs = [ "out" ];
  meta = recursiveUpdate old.meta {
    outputsToInstall = [ "out" ];
  };
})
