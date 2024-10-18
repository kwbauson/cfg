scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-10-18";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "8d4658010d8ba2f49bc35f46ee8ce707555d3ace";
    hash = "sha256-H1NnDTudFo05/QtPfMZjlohBLKTWl3dtKQs1Rbd+cmc=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
