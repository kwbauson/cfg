scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-07";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "e53e5cc77bb6e1073b136ec98a0a9cfbb582c7a8";
    hash = "sha256-LDTZ2aRlnXSwYZnUnv6cJ3WQp8LmDYKMtouv2gTQmAA=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
