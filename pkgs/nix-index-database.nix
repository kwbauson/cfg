scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-05-31-064259";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-It27RZIQFGvpPNYRbXSaDM8wHt3NCLHam44cffVphL4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
