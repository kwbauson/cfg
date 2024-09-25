scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-09-25";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "8cc8dc819ff77f61ac533cf0bd9c196294d3632e";
    hash = "sha256-CGV+pIp9anQ58xVaqT+Qv/hMpjC2YeJaRnHDqIoOE4A=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
