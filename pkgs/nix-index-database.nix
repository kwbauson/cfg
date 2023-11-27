scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-11-26-030655";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-TzZzrEraf9X7zKad5HTLfys2JUM1fkG5uElo4tNVq60=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
