scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025.4.8";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-ffyYpwFcDA7B+nIvAKNgbznlwvmPJdaiQTNABjqCYuo=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
