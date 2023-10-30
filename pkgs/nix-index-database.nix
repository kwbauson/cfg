scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-10-29-033859";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Uq91W7FBaxnlyXqaJLMqCEg/wBJ6QKvpWdXecE+B0Yg=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
