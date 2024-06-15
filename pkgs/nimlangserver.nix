scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-12";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "3879966eed20f04ce4254b67c5c6496c06358b79";
    hash = "sha256-hJb98FEPKw0pEQ7a2HC4CDZOoqKN7N2R2hmECLmhsCM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
