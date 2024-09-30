scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.6.0-unstable-2024-09-29";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "ed6cc7438e16a360ec61d5accc3be1bd509ea48f";
    hash = "sha256-A6nTDTbhgIFWSgLZO2U40r3QxS/zrcYxTWouNTy6W6w=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
