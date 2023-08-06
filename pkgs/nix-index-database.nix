scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-08-06-033242";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-nTyhu8X1NyBKbdhtSAmRliIwBF316KG/hhWzwtOagXw=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
