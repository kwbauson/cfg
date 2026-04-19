scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-03-29-050203";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-3Yey22z7qiPiDLhLbTq7l1cxkWJ8Jndam+PEgCglQIM=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
