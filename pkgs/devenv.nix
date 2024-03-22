scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-22";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "984707a775ad1540317ba455640e1748c27b163f";
    hash = "sha256-MJU5WszOrHsk63sMYKFw+NY1mALFCKAogZJDBiL5eyw=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
