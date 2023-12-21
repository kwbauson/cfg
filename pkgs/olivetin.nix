scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.12.21";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-hG5fbn05BRCDmt9BkEVWNTzx/m25l05sG7KCIaJVYAs=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
