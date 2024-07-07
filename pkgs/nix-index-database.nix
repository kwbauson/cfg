scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2024-07-07-025737";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-8fe3crUTIr380j2bo+39M0/n94rk8E31KFM/EDH4Vt8=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
