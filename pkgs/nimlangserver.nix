scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.4.0-unstable-2024-09-23";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "1bd46086d1394364371db937020403357d9704fa";
    hash = "sha256-rTlkbNuJbL9ke1FpHYVYduiYHUON6oACg20pBs0MaP4=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
