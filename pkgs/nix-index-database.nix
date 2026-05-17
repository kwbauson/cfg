scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-05-17-060925";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-LcQYs8fHl0JWr80kidD0z87l5ZRBHEfcOPcvU0QRkNk=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
