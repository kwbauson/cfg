pkgs: with pkgs; with mylib; buildEnv {
  name = "better-comma";
  paths = [
    (
      writeShellScriptBin ","
        ''
          ${pathAdd [ sqlite coreutils fzy nixUnstable ]}
          cmd=$1
          db=$(nix-instantiate --eval --expr '<nixpkgs>' 2> /dev/null)/programs.sqlite
          sql="select distinct package from Programs where name = '$cmd'"
          packages=$(sqlite3 -init /dev/null "$db" "$sql" 2> /dev/null)

          if [[ $(echo "$packages" | wc -l) = 1 ]];then
            if [[ -z $packages ]];then
              echo "$cmd": command not found
              exit 127
            else
              attr=$packages
            fi
          else
            attr=$(echo "$packages" | fzy)
          fi
          if [[ -n $attr ]];then
            exec nix --extra-experimental-features 'nix-command flakes' \
              shell "${cfg.outPath}#$attr" --command "$@"
          fi
        ''
    )
    (
      writeTextDir "etc/bash_completion.d/better-comma.sh"
        ''
          _better-comma()
          {
              ${pathAdd sqlite}
              local cur prev opts db sql
              COMPREPLY=()
              cur="''${COMP_WORDS[COMP_CWORD]}"
              prev="''${COMP_WORDS[COMP_CWORD-1]}"
              db=$(nix-instantiate --eval --expr '<nixpkgs>' 2> /dev/null)/programs.sqlite
              sql="select distinct name from Programs where name like '$cur%' order by name"

              if [[ $COMP_CWORD = 1 ]];then
                COMPREPLY=( $(compgen -W "$(sqlite3 -init /dev/null "$db" "$sql" 2> /dev/null)" -- "$cur") )
              else
                COMPREPLY=( $(compgen -f -- "$cur") )
              fi
              return 0
          }
          complete -F _better-comma ,
        ''
    )
  ];
}
