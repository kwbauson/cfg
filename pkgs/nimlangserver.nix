scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-07";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "3eb83dabfba18f079fca72f1b72199f01beb13b5";
    hash = "sha256-+vBDFSGay9jjQKNxNOtwclQDhN91a4gLHnIkihZVlI0=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
