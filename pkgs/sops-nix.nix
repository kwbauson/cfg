scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-07-04";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "f1406619a3884cd5c47992a70b8b35c9c0fcb4c9";
    hash = "sha256-aCWC8ngycU7OdJrU2+Je3qf+1a2ykuBvpPhZT/9tXMc=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
