scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-02-23-031515";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FcjApisASa4Ei+eh7O8FM+A6qfZfEJeO7zdl0naGuaI=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
