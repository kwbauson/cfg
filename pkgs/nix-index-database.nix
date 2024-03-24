scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-03-24-030726";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-wkMs6KKmQDkSzDRGrGQtB9ovqkI2MBCiNzRY8Ai9XFQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
