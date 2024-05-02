scope: with scope;
importPackage (attrs: {
  inherit pname;
  version = "0.0.20-unstable-2024-01-26";
  src = fetchFromGitHub {
    owner = "garnix-io";
    repo = pname;
    rev = "a892794e7b41b75e2a899a36ea4f619c0e5ad026";
    hash = "sha256-GV2xL+veABI/H+fWt6Gc9qlOx5fG1u8ELRSffLap2+4=";
  };
  package = compatGetFlakeDefault attrs.src;
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
})
