scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-08-30-083329";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-7xnty3dU9cHMfoYfgfmser4LgybfTlOitU/2X8MoA1Y=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
