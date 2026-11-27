scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-11-23";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "d5abe5e53200ad48254e8e6bd95e6cef94e66577";
    hash = "sha256-2p8/wnENYHU2Z79Ir/rpq+V1sMI9mSD6xGAlvlbVBUY=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
