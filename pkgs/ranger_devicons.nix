scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2024-02-29";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "ed718dd6a6d5d2c0f53cba8474c5ad96185057e9";
    hash = "sha256-ETE13REDIVuoFIbvWqWvQLj/2fGST+1koowmmuBzGmo=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
