scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-03-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "b14e48596c71f40e02f909698e458b91a00e7827";
    hash = "sha256-FU25PZ+8Nsu+rfDDGdislxC/dmRiktl7xq2ni2RJCTM=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
