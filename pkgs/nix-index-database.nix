scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-05-18-033800";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Mvg2noQeRA4ESsE/qc/7Y5JnF4eRzand604LqLWgXoU=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
