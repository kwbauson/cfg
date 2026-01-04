scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-01-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c636141ffde1c268a5ddd6edea0a4679fc258f2b";
    hash = "sha256-YjKL6kTa3gfpnRiEHHDR4npPJOlr21kjX3asnUtXlbs=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
