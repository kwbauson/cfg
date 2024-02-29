scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.02.28";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-J6SiIO2JJ8qRPP6UTgx69A3kjtTHzlJ20zQfTHfPG1Q=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
