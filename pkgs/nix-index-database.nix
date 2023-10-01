scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-10-01-033420";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-K2T7gXovy3HqKXZfEDorlTuPypOpl088vIvLFjdmeek=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
