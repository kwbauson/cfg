scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-09-24";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "2bd00bd9bb35fe6d114888c8f1c2e946c541dd8f";
    hash = "sha256-TNfgoHsqsYYvaJImlWctfRkh4PseTagzegU1Dgdbehw=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
