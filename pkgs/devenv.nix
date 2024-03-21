scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-03-21";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "a7ba6766c0cc351b8656c63560c6b19c3788455f";
    hash = "sha256-9LnGe0KWqXj18IV+A1panzXQuTamrH/QcasaqnuqiE0=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
