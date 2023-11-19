scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-11-19-030847";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-OSU/i1MxFTVKDTN75jETqp2YAqx6YfUU0Rp1+n7nFU8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
