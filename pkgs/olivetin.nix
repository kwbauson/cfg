scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.02.01";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-wEqDHPI7sq4vM+5fV2mGGia+kkg2RtzRz3doqe9JCYA=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
