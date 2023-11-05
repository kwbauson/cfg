scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-11-05-035517";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-CYHW7pdjRzGLMpbyY6pn3X5C2DicZuXt/Eevyt2xDMg=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
