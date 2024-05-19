scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-05-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "e9396c8eb5fef89530a63511fdb1848404a4b0f3";
    hash = "sha256-FhJRe9P0/lIc5Ol5ZD7aAoaZLevWlWTGRcwQjJVjaQM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
