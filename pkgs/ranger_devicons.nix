scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-04-20";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "a8d626485ca83719e1d8d5e32289cd96a097c861";
    hash = "sha256-sijO9leDXgnjgcVlh5fKYalhjOupwFMRyH0xh2g/rEQ=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
