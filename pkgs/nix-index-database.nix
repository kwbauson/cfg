scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-03-02-031754";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-orxbAUHFbfJzlPmbejFFHq0UtRx4jaynxbzz4cTYaPw=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
