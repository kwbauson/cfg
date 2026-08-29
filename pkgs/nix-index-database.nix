scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-08-23-033710";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Q/GSEuWfklfRikH2D3ODZ59YftDT7Lx3yzDZyHg0jJ8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
