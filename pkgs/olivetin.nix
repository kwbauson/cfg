scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.10.25";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-kIlZlBIdv8eSImP2pG+1ox/H9k+2rWqmlQnzuG1T31M=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
