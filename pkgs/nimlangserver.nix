scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-11-14";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "3ad3c9b627af41c4a1c31b59b0e4a7e5302b7530";
    hash = "sha256-I5ysw/k42SOKgquaSDx5EY5a4s6t9yNCDiYpa5mG1wU=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
