scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.021";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-QYnMfAE/UdIhiHPcV/Y8WDvXcCdzhLFkyXBsYka2WOY=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
