scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-06";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "af34c270e708675c02831c5a4d6d1d3d6efb0854";
    hash = "sha256-rBTtJ3Vln63RwzyVFzcAy6hW5mXTZOLXwJ/p5Sz0T5k=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
