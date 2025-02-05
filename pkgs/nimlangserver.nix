scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-02-05";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "44039ef8bf6646ca36490b5d4e75fbc2896400c7";
    hash = "sha256-2Xim1ZxdliRkfZzmEpsyQCuR4hqmiwbCegS8L/1UNWA=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
