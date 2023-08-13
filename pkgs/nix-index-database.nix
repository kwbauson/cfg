scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-08-13-032820";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-rTTwp1FnBBEU/nXodzP2/wqlb4Fk87nOnsm+lNUlSyM=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
