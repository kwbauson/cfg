scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2025-01-02";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "d5e033af5e684095487318520e42afe770d2f085";
    hash = "sha256-pUrx6IuOdHngfDxAEi1HPBZyi8UUP4JIRlBSr2KV5TM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
