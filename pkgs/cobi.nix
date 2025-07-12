scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-12";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "11c671000b3b340ee8e17029ffe640e5ad030cdb";
    hash = "sha256-HgaZFeasRyI0Ckugm97NP1djIJt95XuqGH/+YQNomHM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
