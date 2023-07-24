scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "G4.1.5";
  src = fetchurl {
    url = "https://cdn.waterfox.net/releases/linux64/installer/${attrs.pname}-${attrs.version}.en-US.linux-x86_64.tar.bz2";
    hash = "sha256-E/PFhKkMUK0P6QBtH+CQbt/aoCztmfDwJwkNIm7Q+UI=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = firefox-unwrapped.buildInputs ++ [ gtk2 ];
  installPhase = ''
    mkdir -p $out/{share,bin}
    cp -r . $out/share/waterfox
    ln -s $out/share/waterfox/waterfox $out/bin
  '';
  meta.platforms = platforms.linux;
  passthru.updateScript = writeShellScript "update-waterfox" ''
    ${common-updater-scripts}/bin/update-source-version waterfox "$(
      curl https://cdn.waterfox.net/releases/linux64/installer/ |
      sed -En 's#.*href="waterfox-(G.*)\.en-US.*".*#\1#p' |
      sort -V |
      tail -n1
    )"
    ${getExe nix-update} --flake --version skip waterfox
  '';
})
