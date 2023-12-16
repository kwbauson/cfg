scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-12-10-030756";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-N91ujkkk8odr+6CtzC3cQS5Zv9esxHH8APxfqSIR75A=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
