scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-04-13-041853";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-xXXx5p2k2B92YRFtsK2r3mm1Vf8Y9uK5Xj4YPULIr8I=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
