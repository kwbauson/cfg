scope: with scope;
let
  init-file = writeText "init-file" ''
    [[ -e ~/.bash_profile ]] && . ~/.bash_profile
    one_command() {
      if [[ $BASH_COMMAND != *_prompt_command* ]];then
        history -a
        exec ${getExe tmux} -L termbar new -d $BASH_COMMAND
      fi
    }
    PROMPT_COMMAND="$PROMPT_COMMAND; trap one_command DEBUG"
  '';
  term = writeBashBin "term" ''
    exec ${getExe kitty} --single-instance "$@"
  '';
  termbar = writeBashBin "termbar" ''
    exec ${getExe kitty} --single-instance --name termbar bash --init-file ${init-file}
  '';
in
buildEnv { name = pname; paths = [ term termbar ]; }
