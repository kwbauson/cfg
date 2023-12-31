scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "2023-12-31-030821";
  src = fetchurl {
    url = "https://github.com/nix-community/${attrs.pname}/releases/download/${attrs.version}/index-aarch64-linux";
    hash = "sha256-bRE2wDvZDrnJic+pjCAwlR6NjXc8RovFLv7VnYWusqQ=";
  };
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    cp $src $out/files
  '';
  passthru.updateScript = nix-update-script { extraArgs = [ "--flake" ]; };
})
