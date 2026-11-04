scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-11-02";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "b18e01ce148eb3efff5de2f2d3181ca53b2b2a54";
    hash = "sha256-GoOvpdsjO5hqZuO6T6ok9u6sJEjO0iPli2zRr9oNUNw=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
