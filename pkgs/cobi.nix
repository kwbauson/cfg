scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "14cd5e2a8fb69224dfa17fc7dc3ae64ee484eb6a";
    hash = "sha256-44UW6W5IxsS5Qc3LLK1S9NTeufAyW510Nwm3bW6Howo=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
