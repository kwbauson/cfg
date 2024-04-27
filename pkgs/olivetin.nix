scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.04.261";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-0M8RlbvnAOEPj7vOE5vPF+Gh1yrMCoDfrYOC0V6kiEw=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
