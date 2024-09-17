scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.09.16";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-wAI+yUI7JJaHMiMSHzfRGB008tz5HjSBI6Q/7w9EC7E=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
