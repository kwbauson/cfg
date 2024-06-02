scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-06-02-030640";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-dQEoLl/Hy1Dfp2r4xv1Z7rf0tGTYxHwv/78Z+5sVV+s=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
