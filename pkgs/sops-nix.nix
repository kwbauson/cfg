scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-09-09";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "13616fff713a9f94055c66f15687ebdc17a335df";
    hash = "sha256-4GuMPW90JSxXWDPUB9M+1m7fYbe3H0apOd86/zBQ2Kw=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
