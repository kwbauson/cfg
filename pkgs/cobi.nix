scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "57475cb824a34816f0669747f0edb49f5cd5c2ed";
    hash = "sha256-bryg1DJPiWfUbv2K9+IvqP/l5JbE2Q5AdR1J6Eq9adY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
