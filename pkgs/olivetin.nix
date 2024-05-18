scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.05.13";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-jAjr28dUijoTS/ZeGWqQEN+zsBLcYN2n3YgtWwceQ6k=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
