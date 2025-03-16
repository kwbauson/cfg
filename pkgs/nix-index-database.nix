scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-03-16-032233";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-5AYki57JicIf0PX8PTOy0jpvFvD9P7l/skMpcos0tZY=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
