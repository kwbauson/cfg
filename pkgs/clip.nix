scope: with scope; writeBashBin "clip" ''
  ${pathAdd [ xsel clipnotify ]}
  if [[ ${boolToString isDarwin} = true ]];then
    if [[ -t 0 ]];then
      pbpaste
    else
      pbcopy
    fi
  else
    xsel
  fi
''
