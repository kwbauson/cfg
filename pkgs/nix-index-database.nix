scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-12-24-030633";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-JpQLNvLSQBIHcbbJTrEs3UT1bOdLI8qaT4X7DfohWjQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
