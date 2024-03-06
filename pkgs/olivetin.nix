scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.03.06";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-kh5j8pRzV4nYO5bYdRZIwQ7eOmIw0uUb9mx+jsGGBls=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
