scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-06-01-035302";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-gqDKAybgBW4uytXjD71HhYAQcH2yEjJZ9Q25uGHH8Sc=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
