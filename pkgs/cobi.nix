scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-03";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "1ec05847afdbd09cf7a9fd5bbbe58ad6ca39e9c6";
    hash = "sha256-w6sV5uCTHMoznJBEgKYPM01FpKDX86OxTBaM/93oBys=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
