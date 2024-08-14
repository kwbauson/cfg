scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-08-11-025748";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-s9PdwgUvG7CaCP8MkXKwZCXMioMB5dmCE7HM8GAEu88=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
