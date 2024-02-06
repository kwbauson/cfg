scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2024-02-05";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "2c3c19dffb4238d01c74515c9eed5088066db243";
    hash = "sha256-HLeiV3c+8fl3kiht01s3H/HGPABPC2033rMB/uXKwLM=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
