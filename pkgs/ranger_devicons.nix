scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-01-08";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "f227f212e14996fbb366f945ec3ecaf5dc5f44b0";
    hash = "sha256-ck53eG+mGIQ706sUnEHbJ6vY1/LYnRcpq94JXzwnGTQ=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
