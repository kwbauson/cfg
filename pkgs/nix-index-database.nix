scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-01-12-031855";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-ObuH+LSOf8++P+9uhSsFW4dKb/5jYzakZ0zUEX3W8p4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
