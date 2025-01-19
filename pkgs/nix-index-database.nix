scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-01-19-031135";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-WlB8DLugldCgDWC8CStXtTLc33KZgfwhWzfKvrwG1FA=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
