scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.2.0-unstable-2024-05-31";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "cef1af967fb912dcc158bdf0f9086ef1963943cf";
    hash = "sha256-Utx+2Tx3MBzXREwuBD0AM054jHpTm/o95QNt6mhxc3w=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
