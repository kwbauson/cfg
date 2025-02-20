scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.2.19";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-/cBzLrSWNdx3dKsf2tpYAonaCqzmV372MI2hVvn4smI=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
