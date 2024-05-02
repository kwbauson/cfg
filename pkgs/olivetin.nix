scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.28";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-H3atiIHvRuwum1uVj79PIkf6M8rV+VBRnm57QmUKwS4=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
