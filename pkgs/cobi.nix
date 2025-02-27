scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-02-27";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7ee51e1dee8827da3d5e7dc558b53a6ad1409ef3";
    hash = "sha256-dPllNdCIYjbsDDzWADU/X9hjQi1hRLOPiz3780ZlKWc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
