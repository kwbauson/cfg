scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0-unstable-2024-08-04";
  src = fetchFromGitHub {
    owner = "jpetrucciani";
    repo = "nix";
    rev = "7ccbb634fb89c5ab34b4323b4cdfbd913a6ceb0c";
    hash = "sha256-G4nLT8o/s8DXkaDOTYY1fbKqko7hLixGWty7Pm6KbD8=";
  };
  pkgs = (import attrs.src { inherit nixpkgs system; });
  passthru.updateScript = unstableGitUpdater { };
})
