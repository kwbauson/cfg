scope: with scope;
let
  echos = {
    hook = /* bash */ ''
      kj() {
        eval "$(kjump jump)"
      }
      bind '"\C-j":"\C-ukj\C-m"'
    '';
    jump = /* bash */ ''
      _min_height=20
      IFS='[;' read -p $'\e[6n' -d R -rs _ _lineno _ _
      _height=$(($LINES - $_lineno + 1))
      if [[ $_height -lt $_min_height ]];then
        _height=$_min_height
      fi
      _kjump_to=$(
        fzf \
          --scheme=history \
          --height=$_height \
          --bind='ctrl-j:jump,ctrl-e:execute(kjump edit {})+abort,ctrl-o:execute(kjump run {})+abort,start:reload(kjump list)'
      )
      if [[ -n $_kjump_to ]];then
        _kjump_to=$(echo "$_kjump_to" | sed "s#^~#$HOME#")
        echo "$_kjump_to" >> ~/.kjump_history
        if [[ ! -d $_kjump_to ]];then
          _kjump_to=$(dirname "$_kjump_to")
        fi
        cd "$_kjump_to"
      fi
    '';
  };
  echoCase = n: arg: ''
    ${n})
    echo ${escapeShellArg arg}
    ;;
  '';
in
addMetaAttrs { includePackage = true; } (writeBashBin "kjump" ''
  set -eu
  cmd=''${1:-}
  shift
  histfile=~/.kjump_history
  if [[ ! -e $histfile ]];then
    touch "$histfile"
  fi
  pre() {
    file=$(echo "$1" | sed "s#^~#$HOME#")
    if [[ ! $file = "/"* ]];then
      file=$PWD/$file
    fi
    echo "$file" >> "$histfile"
    cd "$(dirname "$file")"
  }
  case "$cmd" in
    clean)
      wc -l "$histfile"
      undup "$histfile" | sponge "$histfile"
      wc -l "$histfile"
      ;;
    list)
      (
        run_fd() {
          fd --hidden --ignore-file ~/cfg/ignore --exclude .git "$@"
        }
        if [[ $PWD != $HOME ]];then
          run_fd
        fi
        cd ~
        tac "$histfile"
        run_fd --absolute-path
      ) | awk '!x[$0]++' | grep -vFx "$PWD/" | sed -E "s#^$HOME#~#"
      ;;
    edit)
      pre "$1"
      exec $EDITOR "$file"
      ;;
    run)
      pre "$1"
      exec rifle "$file"
      ;;
    ${concatMapAttrsStringSep "\n" echoCase echos}
    *)
      echo invalid command
      exit 1
      ;;
  esac
'')
