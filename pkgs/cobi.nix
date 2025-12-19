scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0ea64225c1bf4d9239abe224ef67e023e4dc3460";
    hash = "sha256-RYyy7LOIjf7dREAJYM7ozs0EmgYAfqRN98XST0h6bvM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
