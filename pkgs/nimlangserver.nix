scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.0-unstable-2025-01-15";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "ae55a53d63f89195ecf7fb9b648b378c5f9bb93e";
    hash = "sha256-me/AExBY/4oRcgWuPn9sviC9OqfgLAA6lsT9KLKOa3A=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
