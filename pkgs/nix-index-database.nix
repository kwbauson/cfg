scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-01-07-030820";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-yvV5cE0MJuKGKIVkb30BwJBG2CNKo0MbXd0UmaxUUS0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
