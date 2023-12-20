scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-12-19";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "fab40dac57fbc614f6cd9e9588116d7f2427486b";
    hash = "sha256-Qt3S4JK+m+d/uJQL5RWC/PrfBHOwFg1rNYWboFSiOv4=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
