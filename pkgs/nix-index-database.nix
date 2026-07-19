scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-07-19-053822";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-KechgZbsndFUuKUqMV5GSajXAKNYtXYp42c5SVpMjk0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
