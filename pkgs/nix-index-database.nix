scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2026-09-13-074012";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-5Qha+M1xtP/hkFAn4E/G/gTZ7PV4QyRJXjbSv8GsJR4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
