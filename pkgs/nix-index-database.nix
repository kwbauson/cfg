scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-03-23-032447";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-uknvFXxvHbp2rvFo5tbilKOiKm9yaKo4Zmrk0Uzz1pA=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
