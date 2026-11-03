scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-11-01-134459";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-keUWfONJL9UgCGcstDJf+nEAHpuWYzVHJwzkF8dfcfw=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
