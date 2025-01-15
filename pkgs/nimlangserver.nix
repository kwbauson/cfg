scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2025-01-14";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "5adc15be0f785f0caa3b7fc444e54eeb5596602a";
    hash = "sha256-JyBjHAP/sxQfQ1XvyeZyHsu0Er5D7ePDGyJK7Do5kyk=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
