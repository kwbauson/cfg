scope: with scope; stdenv.mkDerivation {
  inherit name src;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = firefox-unwrapped.buildInputs;
  installPhase = ''
    mkdir -p $out/{share,bin}
    cp -r . $out/share/waterfox
    ln -s $out/share/waterfox/waterfox $out/bin
  '';
}

