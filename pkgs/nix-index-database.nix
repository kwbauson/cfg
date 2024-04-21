scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-04-21-030753";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-WSE5mVWUhYl4ZnNFucSc6AdbM6cIhlpUB7LUqG0IU8o=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
