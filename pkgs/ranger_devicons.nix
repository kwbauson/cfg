scope: with scope;
stdenv.mkDerivation {
  inherit pname;
  version = "0-unstable-2024-11-24";
  src = fetchFromGitHub {
    owner = "alexanderjeurissen";
    repo = pname;
    rev = "84db73d0a50a8c6085b3ec63f834c781b603e83e";
    hash = "sha256-sqqsWU5/zBwIpyJKEBiCfosqKNvISWCw8cFgzLcNjUY=";
  };
  installPhase = "cp -r . $out";
  passthru.updateScript = unstableGitUpdater { };
}
