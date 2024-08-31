scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "a5f68d6ca55e55a6733fe3b8afef5e8ea087740f";
    hash = "sha256-WXPQTXK+5BpHk12LYZeRXYovsdItDZg40cNRiX1cGN4=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
