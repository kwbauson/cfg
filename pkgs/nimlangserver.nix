scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-07-18";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "69e94dd6be48cb2bb4ec814b0b2098cb0c11a03f";
    hash = "sha256-mh+p8t8/mbZvgsJ930lXkcBdUjjioZoNyNZzwywAiUI=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
