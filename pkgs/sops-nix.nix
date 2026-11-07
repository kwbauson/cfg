scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-11-06";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "89a234ce2daf6e568a7d4b4fe250afdd23d84e20";
    hash = "sha256-ZlE4BtMjWhfC6rFXLO9Qimn36Ene1INqCgKDDvazjhc=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
