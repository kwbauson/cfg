scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-06-29-034928";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-rmterjXRk7I8AULlH2J71kkUW7qwRB0TUDEBE+fE4JI=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
