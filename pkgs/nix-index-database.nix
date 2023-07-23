scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-07-23-033400";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-rg/hIGmPXblv7LgZyzW9NkP6hl5LqQVNmTGGKAnVJGo=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
