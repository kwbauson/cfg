scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-05-12-030850";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-5RmPopUBaz46J/pcV39NGaQ+qvnWUqJwnrNBYGUlJ64=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
