scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-10-04-085218";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-O0hy7Co49BdOJJd4xHIDjZ6aHy3/0RdffyxIcJcOm6M=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
