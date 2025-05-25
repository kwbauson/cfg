scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-05-25-034005";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-/zruQx2izHyYgexS9rdLCVEX3QeryVEXLAUO3/AIJ1E=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
