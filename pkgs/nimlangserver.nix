scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-06";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "092ce765f3f7382e1eeeece902ba9c06ffc29299";
    hash = "sha256-QcV9HTVMWElXvVF1/vBjc8+JUQPIsVyexqyfImvvFU0=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
