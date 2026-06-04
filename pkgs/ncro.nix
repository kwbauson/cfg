scope: with scope;
importPackage {
  inherit pname;
  version = "2.2.0-unstable-2026-06-04";
  src = fetchFromGitHub {
    owner = "feel-co";
    repo = pname;
    rev = "15a1c0b180a815373d8a61298dbb2baa2dbbf578";
    hash = "sha256-mEEA8YtAWJZlLaci4z7JXuXSL5W5aIrdjCn/6rtcQqs=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
}
