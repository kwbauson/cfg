scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-12-13";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "db19b532ec47011c018d1e136bad703e69643538";
    hash = "sha256-4nR/9Ztm42U8RkvKKfWdkNWVjJTRY7bV4p45K4gBBLM=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
