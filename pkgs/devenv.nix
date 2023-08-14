scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-08-14";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "ade3ae522baf366296598e232b7b063d81740bbb";
    hash = "sha256-gO2DXwXuArjpywgtRTDb3aKscWMbnI7YwFaqvV46yv0=";
  };
  package = (import attrs.src).packages.${system}.default;
  passthru.updateScript = unstableGitUpdater { };
})
