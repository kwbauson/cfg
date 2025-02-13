scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-02-09-031200";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FWTTBvxq+7P96bxp02QrPG3SfGKOCcrd/kfP5Wx5Ta4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
