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
      _kjump_dir=$(FZF_DEFAULT_COMMAND='kjump list' fzf --scheme=history --height=$_height --tiebreak=pathname,index)
      if [[ -n $_kjump_dir ]];then
        cd "$(echo "$_kjump_dir" | sed "s#^~#$HOME#")"
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
  case "''${1:-}" in
    list)
      undup ~/.prompt_pwd_history | grep -vFx "$PWD" | sed -E "s#^$HOME#~#" | tac
      ;;
    ${concatMapAttrsStringSep "\n" echoCase echos}
    *)
      echo invalid command
      exit 1
      ;;
  esac
'')
