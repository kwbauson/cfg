scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.07.03";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-5rAqfIYX2QeUNMWgtBM7wJv7ZCW820HlYUz33hBxMtc=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
