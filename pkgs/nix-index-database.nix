scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-12-15-032933";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-yRlYI6H+Urk2xYRQCWHFDy7aCUACjoe9GPwqt2cVHrY=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
