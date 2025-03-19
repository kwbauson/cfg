scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-03-18";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "7e9fa96954077f24190c9df1546fbb7673d22970";
    hash = "sha256-EUxlpNvQLXzWl8k/M1zhb3xl3MVbbm5R147gHW3QjOc=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
