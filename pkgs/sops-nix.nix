scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-09-02";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "fbf759290e0cb0a98dfc813a4eb7d53ad1dacb57";
    hash = "sha256-gkSH8VUtCo6hnysNmb9DbTuDepH2t5pv+QWjP75xKAk=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
