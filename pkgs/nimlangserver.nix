scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-20";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "bf2185585244d328551cc785e63fe3d000c93bf2";
    hash = "sha256-CuWfD24bYQynuaIZnkz/3u4ETHGuG9lZ6ikdiHxoFbg=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
