scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-05-19-030652";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-gyIH57nii/tXiNxK+45zUr/g7fLSpHzH8OM+uygRcfI=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
