scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-07-14-025924";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-V9ZAyb68gimLqjywQwInkq+Tz0Foe9Z5qAX150UIofo=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
