scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-26";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "32f429bbec5561396df0385528e5bea3959d6491";
    hash = "sha256-ijHoe01Vt+aahWUvIMosHRZEiGxB7jScrq3np/1JXyY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
