scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2025-05-31";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "282d20cc23ffabec45bc087973ed53850e3874b5";
    hash = "sha256-VQZZV1Wxk5o6CpcYvhFuLQAPbJ58pPZxb/4eF9Dsa4g=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
