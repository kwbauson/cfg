scope: with scope;
importPackage {
  inherit pname;
  version = "0-unstable-2026-06-20";
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = pname;
    rev = "420f8d2e9882911f65cfac15cc706f639ba96cca";
    hash = "sha256-NFHmA7H47adqiyp+0iEOyZOQhmigDqA/NBAlf4imB6U=";
  };
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
}
