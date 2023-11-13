scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "unstable-2023-11-11";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "09db1b65b9718f77c138d7bbbb4090f236ce9837";
    hash = "sha256-BdMSaBvB07a+G9p/fv7R/sSxNznLLPkPyzNEiJioWlA=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { };
})
