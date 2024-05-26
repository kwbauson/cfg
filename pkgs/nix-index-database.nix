scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-05-26-030820";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-Dyv/wZMUx6owND/ktlf/VJHcuaEx9xuHmWB0zg/1J7Q=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
