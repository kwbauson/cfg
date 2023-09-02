scope: with scope;
stdenv.mkDerivation {
  name = pname;
  dontUnpack = true;
  src = fetchurl {
    url = "https://gist.githubusercontent.com/kylewlacy/39118604775071fc2fbd0743f9958ea0/raw/6976b1df3e794b2d1d8e7a311b4d9f8f2ae5f0c2/57-add-emoji-support.conf";
    hash = "sha256-vvl3AAvDJiD/lQveXBXCGWp82gn1UjO+TVQ6f589xfY=";
  };
  installPhase = ''
    install -m644 $src -D $out/etc/fonts/conf.d/57-zoom-add-emoji-support.conf
  '';
}
