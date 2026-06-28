scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-06-28-064642";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-TJKeqOA3/khcDRk4zv7KL6aBL9exIxw6pwAmqq3IqTQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
