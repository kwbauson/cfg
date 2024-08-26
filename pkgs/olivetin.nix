scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.08.25";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-/LDfrb5YjoISIF2GUBhMvLW5B715UPaTStT6zxM8DeY=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
