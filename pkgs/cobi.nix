scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-11-02";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7af33b1e147264cc978fa5c0912df64bf1e8c560";
    hash = "sha256-3D3MUR1yDt57pfPKvVUZ/bvfngKtgrFxNIITA4KB6+8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
