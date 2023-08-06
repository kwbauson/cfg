scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "G5.1.10";
  src = fetchurl {
    url = "https://cdn1.waterfox.net/${attrs.pname}/releases/${attrs.version}/Linux_x86_64/${attrs.pname}-${attrs.version}.tar.bz2";
    hash = "sha256-1L66hZ+FKe1k5581MZJ9+yt5Xc+CVE2QAlUHmScFCAQ=";
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
      ${getExe curl} https://www.waterfox.net/download/ |
      ${pup}/bin/pup a |
      grep 'Linux.*\.tar\.bz2' |
      sed -E 's@.*waterfox-([^/]*)\.tar\.bz2.*@\1@'
    )"
    ${nix-update}/bin/nix-update --flake --version skip waterfox
  '';
})
