scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-10-11";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "ee48786c6f9160d2c1a084aac841f68195b8420c";
    hash = "sha256-mVD4XIc5JkqMW2K04IkFUzHgHmyJZlzw5ktfgMDCbKU=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
