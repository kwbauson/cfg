scope: with scope;
buildNimblePackage {
  inherit pname;
  version = "unstable-2023-12-01";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "langserver";
    rev = "3a537e540f8073231b16b860716a087c38b36ff0";
    hash = "sha256-XhLeE3VOTO9IyaX0T5/2UEOpBBwjZkXEWKUU28D7kjI=";
  };
  allOverrides.doCheck = false;
  passthru.updateScript = unstableGitUpdater { };
}
