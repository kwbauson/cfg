scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-22";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "aae7455f3e135d5a6c28e329c53456d19ccc18b5";
    hash = "sha256-+eEfsPCL5sU/QER0K1r85UaTeGFUR2NkPBn567uEomE=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
