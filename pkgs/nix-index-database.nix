scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-04-07-030847";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-1VBw8Uishzp5ncE3QVaxnwoVx46v1HS6llUtndNXBh4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
