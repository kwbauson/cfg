scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-04-20-032939";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-6QkjvKvc3txMbJe05DHSsHdD5YzpSuIwuFKWGMjD+Y8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
