scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "eca328af8b56440b71f1bc31dafd6dee8bf2e071";
    hash = "sha256-Zc1+2SBx1a820Rh6ixoWWayIZUn91DTThVJZM2Cs4Hk=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
