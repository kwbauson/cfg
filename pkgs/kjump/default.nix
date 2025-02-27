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
      _kjump_dir=$(FZF_DEFAULT_COMMAND='kjump list' fzf --scheme=history --height=20)
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
