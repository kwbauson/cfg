scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-10-15";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "44931708c62937c2b1bf7953902989fa5bb9ee1b";
    hash = "sha256-YU1LjDe1o2Ymg5zEiCHbmMXLkDCtxHQRiVqZ3nC5GGk=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
