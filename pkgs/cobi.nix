scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-12-07";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "ae53834586aae7c5752155eb048728bafd3d465a";
    hash = "sha256-Jf++xDjgu4fvR6jBk05XsdSpOCOoM+C9RT+5Z/MTYFE=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
