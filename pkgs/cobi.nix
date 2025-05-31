scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-05-31";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "47c73232f0213c28c753dfd73821054b69debc35";
    hash = "sha256-fM2q4mnSAmPDqC146G8D/LnSBsZFXRGBd7ZBWKbM4gY=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
