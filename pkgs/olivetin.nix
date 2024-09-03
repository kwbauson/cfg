scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.09.02";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-muo8wBqm9PFGa2kn1FBJJ6SDAq58rDC9ZTB602kBTaI=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
