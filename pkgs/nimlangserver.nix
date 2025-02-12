scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "1.8.1-unstable-2025-02-11";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "48ab0d656c4816047d85526a0801f5a07b5c2b82";
    hash = "sha256-ArRtfdzXSuXoYz/oa0cSxqOJz0HCBvjqGXdIzD214NA=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
  meta.skipBuild = true;
}
