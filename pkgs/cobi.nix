scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-10-29";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "5ebcf66bf4418af489c4398ab7b620c199a474d2";
    hash = "sha256-mVL2xSZY5TU61a7iCBIc5uGPL4cKzeFs6n6Bghh0SWc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
