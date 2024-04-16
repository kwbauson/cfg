scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.14";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-Wo38fY5Hv4AEEbrQ4T5Tq9fupK0RveGw+XOviaog5o4=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
