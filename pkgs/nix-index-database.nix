scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-06-21-071954";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-gndTQwU5BRF44Gk8GrSlVkiVeJGX3FpnMvU2blk+5pE=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
