scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-05-24-062331";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-ln0ouTNt++xNRLasgkc6TD+n1p0Hw/Q/dgxsbE2fGZM=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
