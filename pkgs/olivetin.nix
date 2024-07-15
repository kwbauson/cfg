scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024.07.13";
  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${attrs.version}/OliveTin-linux-amd64.tar.gz";
    hash = "sha256-fMgaKYKX8/2aU6NJULdwtD8lrvFhq7CKQa89cW7byKU=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  installPhase = "cp -r . $out";
  meta.platforms = platforms.linux;
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
