scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-16-025740";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-k/IOiMrNglMEF9b6ePJ/6jaeT6PC/6hV3pxVIhT2MEs=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
