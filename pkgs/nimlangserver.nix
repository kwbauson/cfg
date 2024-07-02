scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-06-28";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "8ef7420dae7561ee291c9de25429c6b2f4bba396";
    hash = "sha256-KCdCjj+9M1bn1TvQCNQxaNukTGzzXmGsKf8pn4z2TVw=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
