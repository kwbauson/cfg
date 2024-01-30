scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-29";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "46329ea62f97f5fb4e496734c782610ae3fcf4e9";
    hash = "sha256-E1gCO5urx6vLLnslEgGvWKC+GT0uRRtD6xRyZDu/zFE=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
