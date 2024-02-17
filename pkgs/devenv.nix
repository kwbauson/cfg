scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-17";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "40b567388381137a3c49acdff5f4b6946d645a5f";
    hash = "sha256-IWkw+jsVpu7HFNPbOTJaQeMYQ5/eh7ZVScPvtlSo8vc=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
