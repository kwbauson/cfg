scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-03";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "9d211b76555d915fe742bb85d3fa1db094b50ddc";
    hash = "sha256-qxoH4wW1u73RFCBOo+82a5/LUwIYXw01oNu+2yFRQTQ=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
