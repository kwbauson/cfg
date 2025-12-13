scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-13";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "195a5aebd288ee6934b80497b8ad277feffe5708";
    hash = "sha256-Ve9M3N06/fjUEVtBY2AC2FEKnglk6utWXVmz4hI65kY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
