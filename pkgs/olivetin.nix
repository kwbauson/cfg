scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.4.21";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-RvxtXB+MXQHdr4aU8J4G6GDgQHPcx+djMTgsecXIKwk=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
