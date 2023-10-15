scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-10-15-033241";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-ZkxmsjIrGe7Z3v8glwYHDrX8KORD5EOYGz2vqWxDrQQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
