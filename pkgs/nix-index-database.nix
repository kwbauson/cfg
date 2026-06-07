scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-06-07-065317";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-g/pM5EWDWdMAbJAUzJnkCC8+n+x8kpm5/MnvsPzmLUc=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
