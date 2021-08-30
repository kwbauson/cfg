scope: with scope; stdenv.mkDerivation {
  inherit name src;
  installPhase = "install -Dt $out/bin $src/${name}";
}
