scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-01-21-030727";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-6VCsPkCVTsPsyHdCeTHTzVDP1anUv/vEgTTgFRd48EU=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
