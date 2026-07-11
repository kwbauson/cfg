scope: with scope;
addMetaAttrs { includePackage = true; } (pog {
  name = "clip";
  runtimeInputs = [ osc ] ++ optionals isLinux [ wl-clipboard ];
  flags = [ ];
  script = ''
    if [[ -t 0 ]];then
      osc paste -cp
    else
      osc copy -cp
    fi
  '';
  commands = [{
    name = "sync";
    description = "Listens and syncs the primary selection to the clipboard when the clipboard changes.";
    script = ''
      exec wl-paste -nw wl-copy -p
    '';
  }];
})
