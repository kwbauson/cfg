scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-12-22-031612";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-D1xCnRENaBgbjQe6+YPo2zbA1o3uHDgzRo3RFy7cXcg=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
