scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.10.18";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-EmwqGY+GKVbMcTfeS6oJqi8oUzdvY94qgGLxIpr17/o=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
