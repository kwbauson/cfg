scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.12.11";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-TV6iuoNJI30YBvkGUh2/QmorbRA/NZpw077PJfZluFI=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
