scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-09-01";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "918b068ce5a7a6352328c11a49b3845b9828aa72";
    hash = "sha256-bh25FKSx1QYBUSOeddveKABbHQstopc2NrihSRXFq9g=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
