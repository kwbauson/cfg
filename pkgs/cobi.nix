scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "d09fa0d3d5ec7e65a893e7b1eda700bf5e24f6b8";
    hash = "sha256-MAftXo4dtiYwTrADHw/8yVhZI7w8ATJ/Q5RyCjU1zG8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
