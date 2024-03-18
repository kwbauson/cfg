scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-03-17-030743";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-aPjt+41c829H+VfsLF5KpOgNz4Cenidhq1qCWkKnnC0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
