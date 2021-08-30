scope: with scope;
let
  urxvt-term = ''
    ${pathAdd rxvt-unicode}
    urxvtc "$@"
    if [ $? -eq 2 ]; then
       urxvtd -q -o -f
       urxvtc "$@"
    fi
  '';
  init-file = writeText "init-file" ''
    [[ -e ~/.bash_profile ]] && . ~/.bash_profile
    ${pathAdd tmux}
    PROMPT_COMMAND="$PROMPT_COMMAND; trap 'history -a; tmux new -d \"\$BASH_COMMAND\"; exit' DEBUG"
  '';
  term = writeBashBin "term" ''
    [[ -n $1 ]] && set -- -e "$@"
    ${urxvt-term}
  '';
  termbar = writeBashBin "termbar" ''
    set -- -name termbar -e bash --init-file ${init-file}
    ${urxvt-term}
  '';
in
buildEnv { name = "term"; paths = [ term termbar ]; }
