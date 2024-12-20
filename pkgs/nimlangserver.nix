scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-12-19";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "5f3657a5a81598e98815a2c177631b7e4bcd29bb";
    hash = "sha256-2nXizsSBN5TFFwY9IkHkKOlR74GHTBPSqBfEaH2O3H8=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
