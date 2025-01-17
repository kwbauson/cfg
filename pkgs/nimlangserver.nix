scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.0-unstable-2025-01-16";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "ac0dc2f98018affae76b86e437ec8313ecb2b77b";
    hash = "sha256-V4LjR8nez/ZTayiFefwyIc23xo8sNqFk8P/ld+Bn3ks=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
