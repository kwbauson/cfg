scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.2.21";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-e2DgBRuHH5X2xTVfi2cHglpFQO652uV39R1BjK7l6GA=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
