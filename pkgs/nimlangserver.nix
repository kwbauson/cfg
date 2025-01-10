scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2025-01-09";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "8a5889f1a2a89ea797d84b930cc50976b8cbeeb5";
    hash = "sha256-UzLO81K5hewpql6x2QnkZnJFk4HqaI7enMEIQn6mbjo=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
