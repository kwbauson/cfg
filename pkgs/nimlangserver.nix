scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-07-31";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "70751d68d0b1580e3dfd66496559314298a28faa";
    hash = "sha256-4v2/lOIVKFQoTSerEmNDzCD84WeQ0V3VtIKdNyxWPPA=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
