scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-09-01-031416";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-bnaqGZIsp+yU1G2/49oWIv4Gtm3JrQSsDSoJDDZtp3Q=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
