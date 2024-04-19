scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.18";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-CjleQTDXCkoLBuxcXuxet2e38zCu8Uqbrr//g7Fm4LA=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
