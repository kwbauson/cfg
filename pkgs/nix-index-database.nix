scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-06-15-034405";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-1GqNOEntl4A+XofkanjQlinI//Qsx+8tfcxsp8+BOY4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
