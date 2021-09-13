scope: with scope; stdenv.mkDerivation {
  inherit pname version src;
  installPhase = "install -Dt $out/bin $src/${pname}";
}
