scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-12-08-032901";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FTEsGmuQAR9m1z750mdDxrqoxC//A2JGwicYLTqHFAE=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
