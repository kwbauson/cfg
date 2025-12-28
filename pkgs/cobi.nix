scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2025-12-28";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "0098f59eda2d3de54d5fb0771182c0689d324e21";
    hash = "sha256-/DRDv3J1nqRcgzYaqYRekh1lqNgOJMLe2PKfe7vBSAI=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
