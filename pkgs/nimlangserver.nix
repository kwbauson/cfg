scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-02";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "380e4634f2891a926e40c334161931676b074b5a";
    hash = "sha256-Tx/2aA5q2K44E2tSlbZNwubJDHV9V+8EDFwR5c0Gjn8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
