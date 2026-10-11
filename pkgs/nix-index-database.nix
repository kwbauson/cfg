scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-10-11-092020";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-WbvhyIF3ZE9KBpMFXOw5HzhYHH1Q7K1otdpVZRE/VBo=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
