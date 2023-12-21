scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-20";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "405a4c6a3fecfd2a7fb37cc13f4e760658e522e6";
    hash = "sha256-MbX0XYOEvAuXwi80emHKJsjo1IGQZhoKKnEp2uzgNx4=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
