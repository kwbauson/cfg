scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-02-02-030235";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FeMCNhMWRqxEfx4fADWB41+MmQjQGy/K2dL6N0XqvTA=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
