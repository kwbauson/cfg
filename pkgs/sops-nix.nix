scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-06-22";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "56b24064fdcaedca53553b1a6d607fd23b613a24";
    hash = "sha256-478kKQBvK6SYTOdN2h9jhKJv94nbXRbFMfuL1WshErg=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
