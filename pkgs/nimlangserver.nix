scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.10.2-unstable-2025-04-25";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "506de1b13dbbc8f427ff17ce003a4a54d300f954";
    hash = "sha256-CYx44+C32STMQLTeCsH9nFYtgl5m0VfMqYecQV5tqVk=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
