scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-17";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "d82811864dddd821f525a98490d8a34c940c81e1";
    hash = "sha256-7km5QTzO7lpFHOPwDmYDUchu21KExJcE3tiZX1xZngg=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
