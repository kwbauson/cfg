scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-11-09";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "fe7b4228405aeac2ce7192c2049a6e2bc8637082";
    hash = "sha256-Ivif/kuD68yEOKcZZG3zSwNMFUuIgzUgeJuzcHrQy+8=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
