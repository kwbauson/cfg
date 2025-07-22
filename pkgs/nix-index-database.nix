scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-07-06-034719";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-EFQvn0HyUV7X7DJAPBr0LF6xAw99DSzh8DBgmq4trZE=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  # FIXME passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
