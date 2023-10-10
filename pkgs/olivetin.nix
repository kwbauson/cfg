scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.10.09";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-qEANOFwSnWweFMEE8SzWWyW2OWDBSXhC6+Fv3ESsmtk=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
