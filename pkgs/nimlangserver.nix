scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-31";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "36bd6ff5d9e8c2705a98ed95ec4ca853b91311e2";
    hash = "sha256-lOmqu0k9FWDuMmhWYop7d5YBLIhFMD9+nDKSWg+CFU4=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
