scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-02-01";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "66388570cf8927fee350ca15fcc0cd4ba5550e60";
    hash = "sha256-HJb6AmAbrzamu9Kg+IoiceQrLtT0isv9NhxD3owtiwg=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta.skipBuild = true;
}
