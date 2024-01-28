scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-01-28-030920";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-YtzJOc8AsJ0Ac6VeB5YY1gtKOJtmjhkcJQRaRxdUMdU=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
