scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "c3c6d88552ff337a7a965155b039bc64e5c8eddc";
    hash = "sha256-oycxGfxgLmGlgx7YbhFQgcYJdCnLtb5J+y2c8lQ4qmA=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
