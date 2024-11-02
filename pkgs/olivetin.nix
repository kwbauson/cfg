scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.11.02";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-6hpufND2RjoXD/DqfrJX3Io7T7n6oLdy0iF5hwRe5aQ=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
