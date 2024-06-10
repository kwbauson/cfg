scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-09-074536";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-zycmfSAmg1xI7f1q2Ya2hYAD/yK00gVvfB+d8P8n+8E=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
