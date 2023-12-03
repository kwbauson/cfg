scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-12-03-030712";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-jnfuAktYvI3w9P5GOX5O+mj1BDx6jgV/Lf0Zg8JUI8k=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
