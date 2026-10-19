scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-10-18-072618";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-FYO6T8ovGzCJaUNSyyjiQ2s33V7GWd4Wux1YdqDDeI0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
