scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-05-08-112113";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-G0YNc2wYfDylnRk8W12Y3twymbM66VjTffEpYQVeyYE=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
