scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2024-01-09";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "70895d803eb2f6b080c8abd6e94dbbd4339943d1";
    hash = "sha256-TbcBA2ffp/ip5VwD6MGFTgPiIFSHRkcwKG+GHPptiAI=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
