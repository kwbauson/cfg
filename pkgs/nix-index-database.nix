scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2025-01-05-031613";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-J9KiK7vKGkGSwzizrK6CwsIy5TUWifRtfIR46BeFAb4=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
