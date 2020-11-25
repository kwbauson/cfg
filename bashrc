[[ $UID -eq 0 ]] && _color=31 _prompt=# || _color=32 _prompt=$
[[ -n $SSH_CLIENT ]] && _host="$(hostname --fqdn) " || _host=
PS1="\[\e[1;32m\]${_host}\[\e[s\e[\${_place}C\e[1;31m\${_status}\e[u\e[0;34m\]\w \[\e[0;${_color}m\]${_prompt}\[\e[m\] "

set -o vi
set +h
_promptcmd() {
    ret=$?
    [[ $ret -eq 0 || $ret -eq 148 ]] && rstat= || rstat=$ret

    if [[ -z $rstat && -z $jstat ]];then
      _status=
    elif [[ -z $rstat ]];then
      _status=$jstat
    elif [[ -z $jstat ]];then
      _status=$rstat
    else
      _status="$rstat $jstat"
    fi

    _place=$(($COLUMNS - $((${#_host} + ${#_status}))))

    history -a
    tail -n1 ~/.bash_history >> ~/.bash_history-all
}
PROMPT_COMMAND='_promptcmd'
