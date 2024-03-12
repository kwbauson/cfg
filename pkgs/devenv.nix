scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-11";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "6c0bad0045f1e1802f769f7890f6a59504825f4d";
    hash = "sha256-CjTOdoBvT/4AQncTL20SDHyJNgsXZjtGbz62yDIUYnM=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
