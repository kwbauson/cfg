scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-30-025731";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-WnBzOuCFdFB+mpPqRIR5menq6BTEcOQJkB5LiLUB160=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
