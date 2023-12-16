scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-12";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "ba5e289227ff18715196c4aaefac450c9fb569d7";
    hash = "sha256-+doU067Ph+hU6GKbfeJD8TzZ56mZVCeLXI6j/FVDLnw=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
