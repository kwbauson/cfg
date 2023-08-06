scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-08-04";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "de64ab26fb581c00a803381d522c6b3e48b79415";
    hash = "sha256-6JEhyU08QEkGdRW2L00ynRaoaaR5PaiVUccEUbtTQuU=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
