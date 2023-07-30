scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-07-30-032440";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-tXQEpKLr/9l+wvWxlqBirRR4OubR4dgrWlsj0y7kyz4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
