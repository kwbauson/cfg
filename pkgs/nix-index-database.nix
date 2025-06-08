scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-06-08-034427";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Gu+uDcwdzK0TC7Pi1CA5m+CUR88+SdjM9vCiV5XOtgc=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
