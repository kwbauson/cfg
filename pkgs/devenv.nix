scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-10-11";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "55294461a62d90c8626feca22f52b0d3d0e18e39";
    hash = "sha256-gjtW+nkM9suMsjyid63HPmt6WZQEvuVqA5cOAf4lLM0=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
