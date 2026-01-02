scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "19542f7c3c2a7b7c388f0fdd4ce6317bc4c45ed9";
    hash = "sha256-0EepH24L/8lzs4eFhE/A912PJOnI7UPhP0eyo1poz2I=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
