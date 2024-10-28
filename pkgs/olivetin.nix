scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.10.27";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-sQ9wNP+9NLv9leCx4AUgYnEL6nweVta7af67pZU8IbY=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
