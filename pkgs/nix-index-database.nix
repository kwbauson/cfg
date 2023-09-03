scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-09-03-032725";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Z8381zwxz52HY6NrTPVS+wHYqm0OJlPfSjkbxr4O9o4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
