scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-07-28-025730";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-S79IWSffJqx8Y+LillnGXM/2P16IYsx4bxuVWZQZXU0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
