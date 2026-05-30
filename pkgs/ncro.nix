scope: with scope;
importPackage {
  inherit pname;
  version = "2.0.3-unstable-2026-05-28";
  src = fetchFromGitHub {
    owner = "feel-co";
    repo = pname;
    rev = "e9b6d965ba3f0400b4664f58c0d4e3a2f613d70f";
    hash = "sha256-d1mknKIc4wm/yg/C4p8VC/ACRiDmqIevuLPVMSSEq60=";
  };
  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };
}
