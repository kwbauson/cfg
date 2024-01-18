scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-12";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "fc8e6b38cdb4566827c88bda2e39c6c428c6c575";
    hash = "sha256-UOY1ObOAidn5sFnOYFds2VWrbs0w7GPkZ0/lcK9NJY4=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
