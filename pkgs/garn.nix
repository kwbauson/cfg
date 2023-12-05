scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-05";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "e27f23ee806f138bbfc96f47b1823a8da5a2902d";
    hash = "sha256-dbQG3ctXpa96fEdlrP6Hp33YKL2REtgnWeGrYID+/0Q=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
