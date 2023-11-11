scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-08";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "36b09f7a7a925bb80722f51459ceec80a3803cee";
    hash = "sha256-QaLdeilzygMMNpjRPDW3OVqWfBLO/ahGRWIMp/hZvKQ=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
