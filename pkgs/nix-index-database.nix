scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-07-26-054738";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-bEZo0X44iVi/H8DWvaeXc467MSuoTq0auwNjzmVmjWo=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
