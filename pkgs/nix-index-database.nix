scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-08-20-034804";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-shtCIRJHTF2JUYSvZBr0cEed41tOojKDht8x7sbX+j0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
