scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-05-10-055239";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-vEXghn7YS4DxqI1duTjn5Tf8DXEKxokEbkbSDMzXr4U=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
