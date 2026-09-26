scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-09-20-075601";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-7YwDZFTqZTFRJ2HDEYmbk44LKOOCYw0jXZwBReD0OL0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
