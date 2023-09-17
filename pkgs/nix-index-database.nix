scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-09-17-033648";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-IUMx9UlbxHltpA8D9VCA38FuF9oVaG/pkW7tYi91V60=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
