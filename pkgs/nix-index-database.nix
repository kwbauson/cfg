scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-10-25-074941";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-XuZNShHWCx7dJ/CJbDi7fRMibJ73LYCmB0kdLzhWpu8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
