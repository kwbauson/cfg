scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-04-11";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "031dc73b390cd18122d81e6c0488e3c43bd62863";
    hash = "sha256-YXDz9prDxxhtJL3Iv5d/9qwdz9bc4VB2UV7K2OoB1TM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
