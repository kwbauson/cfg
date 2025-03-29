scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.3.28";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-KCGHAHyGgAcITYWGKf4TfI6rNUfHpt2FL9VPQH8Ty54=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
