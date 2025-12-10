scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-09";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "db1b21b35d86a75607c393a3a928ab00d4c552e2";
    hash = "sha256-eikURGr+DtImp/HnGVJxGiS+9y1g0YnNYfD1GpXtGWY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
