scope: with scope;
stdenv.mkDerivation (attrs: {
  inherit pname;
  version = "G6.0.19";
  src = fetchurl {
    url = "https://cdn1.waterfox.net/${attrs.pname}/releases/${attrs.version}/Linux_x86_64/${attrs.pname}-${attrs.version}.tar.bz2";
    hash = "sha256-SOlxDpf0zjGyqnpvHmiBx9qiLpo61HrfLQivf0q/UJk=";
  };
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = firefox-unwrapped.buildInputs ++ [ gtk2 ];
  installPhase = ''
    mkdir -p $out/{share,bin}
    cp -r . $out/share/waterfox
    ln -s $out/share/waterfox/waterfox $out/bin
  '';
  meta.broken = true;
  meta.platforms = platforms.linux;
  passthru.updateScript = writeShellScript "update-waterfox" ''
    ${common-updater-scripts}/bin/update-source-version waterfox "$(
      ${getExe curl} -sLIw %{url_effective} https://cdn1.waterfox.net/waterfox/releases/latest/linux |
      tail -n1 |
      sed -E 's@.*waterfox-([^/]*)\.tar\.bz2.*@\1@'
    )"
    ${getExe nix-update} --flake --version skip waterfox
  '';
})
