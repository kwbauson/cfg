scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-05";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "71b59bfa77dabf6b8b381f6e18a1d963a1a658fc";
    hash = "sha256-dznegEhRHvztrNhBcUhW83RYgJpduwdGLWj/tJ//K8c=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
