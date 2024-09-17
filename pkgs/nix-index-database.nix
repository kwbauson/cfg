scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-09-08-030302";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-5iTtfSI7CisZ7nAbm442ZAE/yPMLeAglYFQ/Jvt3qA8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  # FIXME passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
