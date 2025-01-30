scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-01-30";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "f6197679091bca4b6c7d07b1716f3c020fe4bb1a";
    hash = "sha256-d3zkvqxOIBMjIbXvkulsnM/7bkVY0QcHn3vJEkgw83A=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
