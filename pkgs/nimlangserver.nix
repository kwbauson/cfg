scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-18";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "4943401f0c55e870896db2439cbe5bd8269e66f5";
    hash = "sha256-90i1rV+XfJuH2mTJFhmyEXgdnF2GRF70tx3iTZquX8M=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
