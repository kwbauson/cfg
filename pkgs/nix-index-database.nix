scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-02-16-031500";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-gs2Wx7BCMJw0mx6ZBcy9yloR3OTOsBVqp5VAE46y/Gk=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
