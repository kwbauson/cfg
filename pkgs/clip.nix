scope: with scope;
addMetaAttrs { includePackage = true; } (pog {
  name = "clip";
  flags = mapAttrsToList (name: mergeAttrs { inherit name; short = ""; }) {
    sync_primary = {
      description = "Listens and syncs the primary selection to the clipboard when the clipboard changes.";
      bool = true;
    };
  };
  script = h: /* bash */ ''
    set -euo pipefail
    ${pathAdd ([ clipnotify osc ] ++ optionals isLinux [ wl-clipboard ])}
    if ${h.flag "sync_primary"};then
      while read -r;do
        wl-paste | wl-copy --primary
      done < <(clipnotify -s clipboard -l)
    else
      if [[ -t 0 ]];then
        osc paste -cp
      else
        osc copy -cp
      fi
    fi
  '';
})
