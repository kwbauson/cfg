scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-11-22";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "dac2ee2658932a4a9480ebbc92f0b244627cb9a2";
    hash = "sha256-WVECDQptbVVQnO4qNDX345takIsC+mLbn/eQK2DqA7Y=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
