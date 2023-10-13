scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.10.12";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-UPuYBwZ2MHLLgBLRIA7WBYzdWF1PcBuLPqYRgqD3AA8=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
