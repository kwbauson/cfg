scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-07-05-062608";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-9PrJKZ2xaE49X6qgiQepfX4YeLNUwFiQeT466LWN4JU=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
