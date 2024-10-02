scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.10.02";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-Ls3wKq7bXyZ0y33M69IiSZRq+4FrsyWidUOD8/PWtaM=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
