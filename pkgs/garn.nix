scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-29";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "f5843001012ef790dc3bdb2e0ce9cd5d331cfefe";
    hash = "sha256-Czzkl5cNf6YZWqMQjwF9RIS1mLh3+nONp7H55+hGCqM=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
