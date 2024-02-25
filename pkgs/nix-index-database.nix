scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-02-25-030647";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-w7oTK5IMpzBuK2j/7Ur1456VYI8wCQdfiSsVFJaeCQs=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
