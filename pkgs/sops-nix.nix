scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-08-13";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "a8627b21b9107c5711c96b84f32a9a4b3d45295f";
    hash = "sha256-gkig4nPi1CWc4Z50GBsjE4ygSE7hMpl/TwID2an2Cck=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
