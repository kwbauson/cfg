pkgs: with pkgs;
let
  urxvt-term = ''
    urxvtc "$@"
    if [ $? -eq 2 ]; then
       urxvtd -q -o -f
       urxvtc "$@"
    fi
  '';
  init-file = writeText "init-file" ''
    [[ -e ~/.bash_profile ]] && . ~/.bash_profile
    PROMPT_COMMAND="$PROMPT_COMMAND; trap 'history -a; bash -c \"\$BASH_COMMAND\" < /dev/null & exit' DEBUG"
  '';
  term = writeShellScriptBin "term" ''
    [[ -n $1 ]] && set -- -e "$@"
    ${urxvt-term}
  '';
  termbar = writeShellScriptBin "termbar" ''
    set -- -name termbar -e bash --init-file ${init-file}
    ${urxvt-term}
  '';
in
buildEnv { name = "term"; paths = [ term termbar ]; }
