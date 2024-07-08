scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.07.07";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-vrIHA4QQgQFn6nMQ4G9BY8opEMh08wwnygN12mXbzME=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
