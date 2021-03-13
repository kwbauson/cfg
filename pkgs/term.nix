pkgs: with pkgs; with mylib;
let
  urxvt-term = ''
    urxvtc "$@"
    if [ $? -eq 2 ]; then
       urxvtd -q -o -f
       urxvtc "$@"
    fi
  '';
  init-file = toFile "init-file" ''
    [[ -e ~/.bash_profile ]] && . ~/.bash_profile
    PROMPT_COMMAND="$PROMPT_COMMAND; trap 'history -a; bash -c \"\$BASH_COMMAND\" < /dev/null & exit' DEBUG"
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
