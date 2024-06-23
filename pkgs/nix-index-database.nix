scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-23-025745";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-L+EJ1Vff5mB+DtBmEneWJz34Rjqt5C4wZZvmVHZYtTY=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
