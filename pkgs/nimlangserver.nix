scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.0-unstable-2025-03-25";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "cc44c9a1d2278dd68a56e9ed23d90211261d52bb";
    hash = "sha256-2LyLQeaZyhb2l07yguT6Uc1WXK4Wif3vVCMzLhz/fGs=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
