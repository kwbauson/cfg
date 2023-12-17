scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-12-17-030802";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-f0oiIpaz1CjaPf1oAFDk5TZz+RWWpIuCpirLUdMUjRs=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
