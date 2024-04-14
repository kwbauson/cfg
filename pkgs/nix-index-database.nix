scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-04-14-035802";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-OI6S+N5YvpiPKJ5Q6JKn2ggvuxz/hP0GUm7yTU1LAdg=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
