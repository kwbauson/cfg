scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-21";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "722389208c49cd811ca7fb9a96e2c2adafd050d7";
    hash = "sha256-HRug5f2PHXbRWEexPvc3USeXogxIjVmZYO08BPNWXq8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
