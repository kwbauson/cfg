scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-14";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "bbc1127dda465c7d60cf6a6a95291602dd0c6237";
    hash = "sha256-EnlXpAi0YVWXMtQ19r5/wNsSgjwgLnPQ5uD2EfnH7ok=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
