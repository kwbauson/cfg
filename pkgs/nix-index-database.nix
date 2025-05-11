scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-05-04-033656";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-mpecnW2PX6VJBJsVSsxLmBFjCRLvbq8boQdka4l4s20=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  # passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
