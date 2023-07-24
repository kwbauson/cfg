scope: with scope; (runBin pname ''
  cat ${qutebrowser-qt6}/share/qutebrowser/scripts/open_url_in_instance.sh |
    sed 's/_url="$1"/_url="$\{1-about:blank}"/' |
    ${optionalString isDarwin "sed 's:_ipc_socket=.*:_ipc_socket=/tmp/qutebrowser-socket:' |"}
    sed 's/"$_qute_bin"/exec "$_qute_bin"/' |
    sed 's:^_qute_bin=.*:_qute_bin=${qutebrowser-qt6}/bin/qutebrowser:'
'').overrideAttrs (_: {
  meta.platforms = platforms.linux;
})
