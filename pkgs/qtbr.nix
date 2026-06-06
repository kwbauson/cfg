scope: with scope;
addMetaAttrs { platforms = platforms.linux; } (
  runCommand pname { } ''
    install -D <(
      cat ${qutebrowser}/share/qutebrowser/scripts/open_url_in_instance.sh |
        sed 's/_url="$1"/_url="$\{1-about:blank}"/' |
        sed 's/"$_qute_bin"/exec "$_qute_bin"/' |
        sed 's:^_qute_bin=.*:_qute_bin=${qutebrowser}/bin/qutebrowser:'
    ) $out/bin/${pname}
  ''
)
