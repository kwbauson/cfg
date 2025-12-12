scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f8e1368b15192aa4a58a042d5a86feab77dbefb1";
    hash = "sha256-H6BvG7pmSVlecD0VgaFGdQ8xyPY+9iQTLsm96lqhhwY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
