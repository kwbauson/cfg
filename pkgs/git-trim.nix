scope: with scope; stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2013-08-14";
  src = fetchFromGitHub {
    owner = "dstnbrkr";
    repo = pname;
    rev = "68322f146a443937e8f59aab4fa3dd0eb976a4db";
    hash = "sha256-AWxB4JS+L6XqD9jaFofoMCNQAsRIOQ4nv4Jo6D40P/g=";
  };
  installPhase = "install -Dt $out/bin $src/${pname}";
  passthru.updateScript = unstableGitUpdater { };
}
