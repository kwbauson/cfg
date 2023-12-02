scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.12.1";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-paCzQu6599kTvefj/2tB7bG0hjwMYffGgCRhGQvcvsA=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
