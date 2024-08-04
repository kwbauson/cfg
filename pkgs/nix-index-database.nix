scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-08-04-025735";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-EToCZsNd6MYod0j2YZUCzsKI9nTjKjZga96xERKevcc=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
