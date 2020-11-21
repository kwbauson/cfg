pkgs: with pkgs; stdenv.mkDerivation {
  inherit name src;
  nativeBuildInputs = [ unzip ];
  unpackPhase = "unzip $src";
  installPhase = ''
    mkdir -p $out/Applications
    cp -r Amethyst.app $out/Applications
  '';
}
