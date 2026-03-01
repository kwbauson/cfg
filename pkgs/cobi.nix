scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-01";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "85f1d750c36063ef901de8018cc999351bce9323";
    hash = "sha256-hFknHx8r90WMXlc5YtV0J3d0U73POSiZMsne1Kop7fI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
