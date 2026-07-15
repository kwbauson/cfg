scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-07-12-134147";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-dxoFnBaIe4PuAMFeUxYdM+yEtfrMjQMok2ntgP7eR20=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
