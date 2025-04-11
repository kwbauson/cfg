scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-10";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "4dfffaaf6f133d0b5c756e259d146eabee151a0f";
    hash = "sha256-xbzBVm4pRaxo2e9eOvkNcnIH1lHzdmsEUTw/J72YgGA=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
