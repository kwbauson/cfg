scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-08-25-025816";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-53oBL5ISSPrq6HBVDKi9L6yLrWjClQnjYzLfXLSVn8U=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
