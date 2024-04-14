scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.11";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-46A3O0qwqToE2v9lsbpJju/t6UOR29p36ssluJ5pkMA=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
