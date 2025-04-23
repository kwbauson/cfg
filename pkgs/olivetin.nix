scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.4.22";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-uV9l6HrFP8SrG6umxd3XvlU3gfGY4ELLMNxEy5Ak0/Q=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
