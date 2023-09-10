scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-09-10-033525";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-asRhFNt81dHRx0rW27X76eCXLf8cVH98RUg6ZfWtIWc=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
