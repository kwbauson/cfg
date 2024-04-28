scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-04-28-030722";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-S6bSkrd+N1VJvLz9uZX3cgnm6TF88F9dgqllXNmaCco=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
