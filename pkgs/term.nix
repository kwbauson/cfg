scope: with scope;
let
  init-file = writeText "init-file" ''
    [[ -e ~/.bash_profile ]] && . ~/.bash_profile
    ${pathAdd tmux}
    PROMPT_COMMAND="$PROMPT_COMMAND; trap 'history -a; tmux new -d \"\$BASH_COMMAND\"; exit' DEBUG"
  '';
  term = writeBashBin "term" ''
    exec ${kitty}/bin/kitty --single-instance "$@"
  '';
  termbar = writeBashBin "termbar" ''
    exec ${kitty}/bin/kitty --name termbar bash --init-file ${init-file}
  '';
in
buildEnv { name = pname; paths = [ term termbar ]; }
