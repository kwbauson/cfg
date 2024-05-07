scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-05-05-030852";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-plewqdInLFmEVAVvGzQdifQ5/fh4bDsQeZlnnxoiAII=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
