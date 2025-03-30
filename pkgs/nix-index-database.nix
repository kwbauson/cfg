scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-03-30-032852";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-OhXtIiYnvzqoYdkgBYoY7MV1CfHahB3g59co0r7g1zI=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
