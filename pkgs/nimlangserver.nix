scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-11";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "43d3023c0f6e1e31b709fa60ed985cb825574dfa";
    hash = "sha256-He7lJdVUxGWVCZFPLhGWGiuT4HIIkZiAZ/+qi6dDrsA=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
