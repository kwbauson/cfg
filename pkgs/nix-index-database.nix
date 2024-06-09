scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-09-030647";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-HMr207906gq9MnC7dTsBjFVxWWTrAuCuhhZthzmnaSM=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
