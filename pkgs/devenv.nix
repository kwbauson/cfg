scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-23";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "ad0ae333b210e31237e1fc4a7ddab71a01785add";
    hash = "sha256-d24+re0t8b6HYGzAPZCIJed85n23RUFXQa2yuHoW0uQ=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
