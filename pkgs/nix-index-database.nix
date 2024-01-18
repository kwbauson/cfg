scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-01-14-030810";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-C5/3WfzG7Wv//LMA50un/jbrpa62LVGo20HTzEQmAes=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
