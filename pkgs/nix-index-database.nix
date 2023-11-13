scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-11-12-034340";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-2OIPevS6PFTxmzJgqFEOiyyVuGAD0olTF6ewdaWj5uk=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
