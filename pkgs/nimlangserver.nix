scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-10-01";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "5ccf289d667b57e998c772d39925a08865b35623";
    hash = "sha256-OI+90aVbQIlaP9sPtH6Zf45SPtxXQm8df8/tAbr2gIU=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
