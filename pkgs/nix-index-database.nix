scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-03-09-025742";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-51Shci4k+Sbe3I6crXCePK2ZvsBBmF4AKoJttOOidmw=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
