scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-02-21";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "f5d594f79022f4468fae9d04418cb607890a9347";
    hash = "sha256-2q3tdg3TirbrTEPaVFTfxMG0TJdE77GsC6s5aHJhWkQ=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
