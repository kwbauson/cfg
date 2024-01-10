scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2024-01-09";
  src = fetchFromGitHub {
    owner = "cachix";
    repo = pname;
    rev = "18ef9849d1ecac7a9a7920eb4f2e4adcf67a8c3a";
    hash = "sha256-SoC0rYR9iHW0dVOEmxNEfa8vk9dTK86P5iXTgHafmwM=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
