scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2026-03-16";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "88a98856a31c5b5acf2a7eca2d8942c35f1747e2";
    hash = "sha256-6phv9A2VN8sMeVlg0cwjCDTnoUSXFY24ZSVzRGAbun8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
