scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-07-19";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "3c2db7ba318e6420cbaa90b3dbd24cd1f7db50df";
    hash = "sha256-pw9WRi7p8dtiQnEVsN3kKuZrLu9puHdTDWJkpmlqgio=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
