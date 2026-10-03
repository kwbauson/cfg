scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-09-27-083517";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-ZVXLdHgtYCJTbfYwbQ1b8rG+ZxV8UizLp5VfcpuTu4M=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
