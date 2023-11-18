scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-16";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "525d60c44de848a6b2dd468f6efddff078eb2af2";
    hash = "sha256-OpukFO0rRG2hJzD+pCQq+nSWuT9dBL6DSvADQaUlmFg=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
