scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-06-05";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "1bcaff0366a9d345313dc5af14002cfdcddabb82";
    hash = "sha256-qvWqKVS4C5OO6bgETBlVDwcv4eamGlCUltjsBU3gAbA=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
