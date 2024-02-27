scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.02.27";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-wXtUitNkqN3y3SPL/rCPTFIG1d5Gn6Al0B7ljeHLvMc=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
