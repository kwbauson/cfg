scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-14";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "e681a99ffe2d2882f413a5d771129223c838ddce";
    hash = "sha256-mEN+8gjWUXRxBCcixeth+jlDNuzxbpFwZNOEc4K22vw=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
