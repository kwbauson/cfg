scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.12.17";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-4AnVCZe5mpv+pCOZJcgWbjZxzsfHcgIzCqYhLKDwspg=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
