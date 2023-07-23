scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023.03.25";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-s+6Em0r03dicTO4BrgfuaJYog2+USJlvFOGnAw9bD3E=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
