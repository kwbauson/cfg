scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.4.14";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-pM9hYLnfeJH9uGWvzaXxebdfZOahkIM1pIFIszDY2DI=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
