scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-09-18";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "1e73e8f7176d65e1b55e324de099bbfff4b2c574";
    hash = "sha256-k+I+R6uwHX3VcJ7326qLV6vCahZUgsVl+i8sSU/Stxk=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
