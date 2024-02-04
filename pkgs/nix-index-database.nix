scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-02-04-030719";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-QoECgXvRzh5kGj1RWXg+1ZUfeXcN/7W1IT+XTWRM5r0=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
