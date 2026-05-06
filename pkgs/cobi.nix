scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-05-06";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a437184f4ad2a8686dfc11c96926fa767668b6a8";
    hash = "sha256-cIauIiOUNoYhR+Zl4sMGqC9+FXS74jKz4Y/lu/VCSvY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
