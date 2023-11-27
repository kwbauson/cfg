scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-25";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "0e61454d1506bb95a4d3a61eb4791cf82b24bfdc";
    hash = "sha256-0u1ZmHr8mjrb7VQdXe1H7t9nLyPCjGLFFTnyulHz0x8=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
