scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.06.01";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-KoOZg75zQN50XXB/xj1Hmxwze55WtUdi/jj+YtDGUgc=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
