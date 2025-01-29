scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-01-26-030915";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-bFG764aclym2HNR7hX4Qv87KtG/AqSOYbodv58mDDnE=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
