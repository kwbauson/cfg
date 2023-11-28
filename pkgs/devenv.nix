scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-28";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "a7c4dd8f4eb1f98a6b8f04bf08364954e1e73e4f";
    hash = "sha256-NctguPdUeDVLXFsv6vI1RlEiHLsXkeW3pgZe/mwn1BU=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
