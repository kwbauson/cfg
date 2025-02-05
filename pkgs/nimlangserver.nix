scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-02-03";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "7db4cf60cb5e7a90a698fd49118df644595199d4";
    hash = "sha256-KwIjZ4sSWTyH8rXR1sDnS/yfVx+Z/EaRCzfv4UCIu/0=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
