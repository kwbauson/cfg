scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-09-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "43d2f50d9759708bf81de25b9083e6d838eb8be8";
    hash = "sha256-fdrq4git14IAwqoyoU5tMvBtJ8HFB33WvBtoWbeaeiM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
