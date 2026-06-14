scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-06-14-070944";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-1JmpLyZt0XJ/EbmqSbusUusvkb+P7gwITaHHO0Ud3i8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
