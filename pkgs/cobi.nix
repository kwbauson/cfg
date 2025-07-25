scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-07-25";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "4c6b97039983413529383801da4ab3b700d3ee54";
    hash = "sha256-pvYLjtkyCQ8Cu2LMob3zl9TEpHcAIQo17E7LgZNZXm8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
