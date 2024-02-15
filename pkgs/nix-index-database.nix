scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-02-11-030837";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-v+scYKPIhUQQtVaJilWb4p3H9fmNmz0ubCKBKW5hE64=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
