scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-02-18-030707";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Bi22XThatPkUzEJ0Kkj6UFNGmr5Sxd4dxZ8TrC3/kf8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
