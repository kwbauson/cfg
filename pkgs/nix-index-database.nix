scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-09-24-032915";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FIXjPnrvwSdwgjE+9Ipx0JIg9Gb7XNFXdqCo2fqS5Kg=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
