scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-03-03-030835";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-di9/xeL8n0uywBf1xkMWqFGuAFKm6pqmjnMHwYPbr70=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
