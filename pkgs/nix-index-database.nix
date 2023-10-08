scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-10-08-034126";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-fHQLCZyX4wzWttqMu8IXvNtuWqutJD3xVxarcAx0EQs=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
