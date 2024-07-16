scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.07.15";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-fOMhQDy2JvuqxhVgQGov7I43iRN/jjF+4tJ6BKHb7Gg=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
