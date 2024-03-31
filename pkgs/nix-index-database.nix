scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-03-31-030752";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-OOtMBu4XV6ACEdY8SnC9lf6LPNTdYiUk6G8DvQ6+aJo=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
