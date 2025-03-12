scope: with scope;
pog {
  name = "clip";
  flags = mapAttrsToList (name: mergeAttrs { inherit name; short = ""; }) {
    sync_primary = {
      description = "Listens and syncs the primary selection to the clipboard when the clipboard changes.";
      bool = true;
    };
  };
  script = h: ''
    set -euo pipefail
    ${pathAdd [ clipnotify xsel osc ]}
    if ${h.flag "sync_primary"};then
      export DISPLAY=:0
      while read -r;do
        xsel --output --clipboard | xsel --input --primary
      done < <(clipnotify -s clipboard -l)
    else
      if [[ -t 0 ]];then
        osc paste -cp
      else
        osc copy -cp
      fi
    fi
  '';
}
