scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.10.17";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-ewhLobpuOlZy+RtyS7lWvc4u14PmNM661L1HEix6N+o=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
