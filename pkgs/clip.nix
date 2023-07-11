scope: with scope; writeBashBin "clip" ''
  if [[ ${boolToString isDarwin} = true ]];then
    if [[ -t 1 ]];then
      pbpaste
    else
      pbcopy
    fi
  else
    xsel
  fi
''
