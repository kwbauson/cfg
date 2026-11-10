scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-11-08-093425";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-3XlVhSdZIqDRze/PbzMBYgP9xLord+bFHzGmWRbItfQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
