scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8bf77b00ff6672617041fdef7e5d2c340cde6baa";
    hash = "sha256-YFpgdsh3nzvJdx3xKGE2yY+wBJWKjMaauEuP1OiRQ7g=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
