scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-09-06-071918";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-3DCJlmgrt6iyl/tIV/pXgVT7tpPDp9pTJLJtOV1m+K0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
