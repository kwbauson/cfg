scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.05.24";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-esThgnwSTToy9r7BHlAOCxRY04JJ2WdmpwjOqkQ3h10=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
