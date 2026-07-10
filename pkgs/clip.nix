scope: with scope;
addMetaAttrs { includePackage = true; } (pog {
  name = "clip";
  flags = [ ];
  commands = [{
    name = "sync";
    description = "Listens and syncs the primary selection to the clipboard when the clipboard changes.";
    script = ''
      ${pathAdd (optionals isLinux [ wl-clipboard ])}
      exec wl-paste -nw wl-copy -p
    '';
  }];
  script = ''
    ${pathAdd [ osc ]}
    if [[ -t 0 ]];then
      osc paste -cp
    else
      osc copy -cp
    fi
  '';
})
