scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-03-22";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "0a9e0f12c847a25f5f61709e6287745b9e3e0650";
    hash = "sha256-WO6N60RpiraPzFlMIuKlBEVWIol8S+UYdtGwcHEzDQE=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
