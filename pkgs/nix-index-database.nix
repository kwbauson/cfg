scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-07-21-025749";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-YmeK5uvOI3lmpcL0ITk1RPTRcSo0aeneIu3kiIzJ48Y=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
