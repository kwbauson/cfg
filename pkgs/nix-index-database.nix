scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-12-29-031725";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-KxRhl7M0dalLFKlCA4zZsN2+1WlQ6MzSk1Wg3reAiGk=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
