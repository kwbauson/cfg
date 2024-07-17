scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.07.153";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-Nqv96XV91abekGAUz1C5lU0fglwtNg96RcLupWjDcA0=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
