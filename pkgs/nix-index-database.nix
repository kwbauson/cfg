scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-03-10-030724";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-tVkJNNJDrHxHVc3FVr9bItEd2xVpEeEbfG2n8UCcY4Q=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
