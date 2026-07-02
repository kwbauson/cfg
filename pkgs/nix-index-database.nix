scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-07-02-200945";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-EISrykia/i/Dspcr2/cBGFbxEAJawERoulcq4m6HwrA=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
