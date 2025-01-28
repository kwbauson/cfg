scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-01-23";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "3cc0e195db10fdd4c2f6a3e233f8266ec9662704";
    hash = "sha256-pbWKlFuFSha5KgRpsesBdGYlxZinG2Q8jflMOrY9SzU=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
