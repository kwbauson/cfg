scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-04-06-032615";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-aXHwmBe94gZUe43XiqCQxMq+aQvRmdLw1jV/fXVyqHA=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
